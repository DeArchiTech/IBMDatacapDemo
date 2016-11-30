//
//  IBMUIImage.swift
//  IBMCaptureSDK-Sample-Swift
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit
import CoreImage

class IBMUIImageEffects {
    static func CIBlackAndWhite(image:UIImage?) -> UIImage? {
        
        guard let cgImage = image?.CGImage else {
            return image
        }

        let originalImage = CIImage(CGImage: cgImage)
        let filter = CIFilter(name: "CIColorMonochrome", withInputParameters: [kCIInputImageKey:originalImage, "inputIntensity":NSNumber(float: 1.0), "inputColor": CIColor(color: UIColor.whiteColor())])
        
        guard let outputImage = filter?.outputImage else {
            return image
        }
        
        let context = CIContext(options: nil)
        let imageReference = context.createCGImage(outputImage, fromRect: outputImage.extent)
        let newImage = UIImage(CGImage: imageReference!)
        
        return newImage
    }
}
