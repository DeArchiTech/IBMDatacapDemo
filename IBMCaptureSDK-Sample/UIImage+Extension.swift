//
//  UIImage+Extension.swift
//  IBMCaptureSDK-Sample-Swift
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func whiteDotImage () -> UIImage {
        
        let size = CGSize.init(width: 10.0, height: 10.0)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale);
        let context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context!, UIColor.whiteColor().CGColor);
        CGContextFillEllipseInRect(context!, CGRectMake(0, 0, size.width, size.height));
        
        let image : UIImage! = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
    
}
