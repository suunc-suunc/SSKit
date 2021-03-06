//
//  QRCodeGenerator.swift
//  QRSwift
//
//  Created by Chris Amanse on 09/20/2016.
//
//

import Foundation
import CoreImage

public struct SSQRCodeGenerator {
    internal let filter: CIFilter

    public var correctionLevel: CorrectionLevel = .M {
        didSet {
            updateFilterCorrectionLevel()
        }
    }
    
    public init(correctionLevel: CorrectionLevel = .M) {
        self.filter = CIFilter(name: Constants.filterName)!
        self.correctionLevel = correctionLevel
        updateFilterCorrectionLevel()
    }
    
    private mutating func updateFilterCorrectionLevel() {
        filter.setValue(correctionLevel.rawValue, forKey: Constants.inputCorrectionLevel)
    }
    
    public func image(with message: Data, outputImageSize: CGSize? = nil) -> CIImage? {
        filter.setValue(message, forKey: Constants.inputMessage)
        
        if let size = outputImageSize {
            return filterOutputImageScaled(to: size)
        }
        
        return filter.outputImage
    }
    
    private func filterOutputImageScaled(to size: CGSize) -> CIImage? {
        guard let image = filter.outputImage else {
            return nil
        }
        
        let scaleTransform = CGAffineTransform(scaleX: size.width / image.extent.width,
                                               y: size.height / image.extent.height)
        return image.transformed(by: scaleTransform)
    }
}

public extension SSQRCodeGenerator {
    enum CorrectionLevel: String {
        case L, M, Q, H
    }
}

internal extension SSQRCodeGenerator {
    struct Constants {
        internal static let filterName: String = "CIQRCodeGenerator"
        internal static let inputMessage: String = "inputMessage"
        internal static let inputCorrectionLevel: String = "inputCorrectionLevel"
    }
}
