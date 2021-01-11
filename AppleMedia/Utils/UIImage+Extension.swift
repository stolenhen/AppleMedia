//
//  UIImage+Extension.swift
//  AppleMedia
//
//  Created by stolenhen on 23.12.2020.
//

import UIKit.UIImage

extension UIImage {
    
    var decodedImage: UIImage {
        
        guard
            let cgImage = cgImage
        else { return self }
        
        let size = CGSize(width: cgImage.width,
                          height: cgImage.height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let context = CGContext(data: nil,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: cgImage.bytesPerRow,
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.draw(cgImage, in: CGRect(origin: .zero, size: size))
        
        guard
            let decodedImage = context?.makeImage()
        else { return self }
        
        return UIImage(cgImage: decodedImage)
    }
}
