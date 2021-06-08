//
//  SSQRCodeScanner.swift
//  SSKit
//
//  Created by SUU NGUYEN on 23/05/2021.
//

import ARKit

public protocol SSQRCodeScannerDelegate: NSObjectProtocol{
    func onScannerResult(_ scanner: SSQRCodeScanner, _ code: String)
}

public class SSQRCodeScanner: NSObject{
    public static let shared = SSQRCodeScanner()
    
    public weak var delegate: SSQRCodeScannerDelegate?
    
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    private lazy var captureSession: AVCaptureSession? = {
        return AVCaptureSession()
    }()
    
    private lazy var queueProcessOutput: DispatchQueue = {
        return DispatchQueue(label: "com.sscom.SSKit.Utilities.QRScannerQueue")
    }()
    
    private override init() {
        super.init()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            self.delegate?.onErrorMessgae(self, "[SSQRCodeScanner]: Can't find camera")
            return
        }
        var videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            guard let captureSession = self.captureSession else {
                self.delegate?.onErrorMessgae(self, "[SSQRCodeScanner]: Can't init capture session")
                return
            }
            if captureSession.canAddInput(videoInput){
                captureSession.addInput(videoInput)
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            if captureSession.canAddOutput(metadataOutput){
                captureSession.addOutput(metadataOutput)
            }
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: self.queueProcessOutput)
            metadataOutput.metadataObjectTypes = [.qr]
            
            self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            self.previewLayer?.videoGravity = .resizeAspectFill
        }catch let error{
            self.delegate?.onErrorMessgae(self, "[SSQRCodeScanner]: \(error.localizedDescription)")
        }
    }
    
    public func setPreview(_ view: UIView){
        if previewLayer == nil{
            self.delegate?.onErrorMessgae(self, "[SSQRCodeScanner]: Can't set previewLayer because of nil value")
            return
        }
        self.previewLayer?.removeFromSuperlayer()
        self.previewLayer?.frame = view.frame
        view.layer.insertSublayer(self.previewLayer!, at: 0)
    }
    
    public func startScanner(){
        self.captureSession?.startRunning()
    }
    
    public func stopScanner(){
        self.captureSession?.stopRunning()
    }
}

extension SSQRCodeScanner: AVCaptureMetadataOutputObjectsDelegate{
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        self.captureSession?.stopRunning()
        self.previewLayer?.removeFromSuperlayer()
        self.captureSession = nil
        self.previewLayer = nil
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.delegate?.onCompleted(self, stringValue)
        }
    }
}
