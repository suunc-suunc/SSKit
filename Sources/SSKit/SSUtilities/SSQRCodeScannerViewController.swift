//
//  SSQRCodeScannerViewController.swift
//  SSKit
//
//  Created by SUU NGUYEN on 24/05/2021.
//

import UIKit

public class SSQRCodeScannerViewController: UIViewController {
    
    public weak var delegate: SSQRCodeScannerDelegate?
    
    public static var defaultViewController: SSQRCodeScannerViewController = {
        let viewController = SSQRCodeScannerViewController()
        viewController.modalTransitionStyle = .coverVertical
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }()
    
    private var buttonClose:UIButton = {
        if #available(iOS 13.0, *) {
            let button = UIButton(type: .close)
            button.addTarget(self, action: #selector(buttonCloseOnTough), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        } else {
            let button = UIButton(type: .system)
            button.addTarget(self, action: #selector(buttonCloseOnTough), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }
    }()
    
    @objc private func buttonCloseOnTough(_ button: UIButton){
        self.dismiss(animated: true)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        self.initializeView()
        self.initializeSetting()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SSQRCodeScanner.shared.startScanner()
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    private func initializeView() {
        self.view.addSubview(self.buttonClose)
        self.buttonClose.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        self.buttonClose.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        self.buttonClose.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier:  0.125).isActive = true
        self.buttonClose.heightAnchor.constraint(equalTo: self.buttonClose.widthAnchor, multiplier: 1).isActive = true
    }
    
    private func initializeSetting() {
        SSQRCodeScanner.shared.delegate = self.delegate
        SSQRCodeScanner.shared.setPreview(self.view)
    }
    
    public override var shouldAutorotate: Bool{
        return false
    }
    
}
