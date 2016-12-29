//
//  Util.swift
//  SDKSampleApp
//
//  Created by davix on 9/28/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//

import Foundation
import UIKit

class ImageUtil{
    
    init(){
        
    }
    
    func createImageUploadParam(image: UIImage) -> Dictionary<String,String>{
        let baset64String = self.createBase64String(image)
        let dictionary = self.createImageUploadDictionary(baset64String)
        return dictionary
    }
    
    func createImageUploadParam(data: NSData) -> Dictionary<String,String>{
        let baset64String = self.createBase64String(data)
        let dictionary = self.createImageUploadDictionary(baset64String)
        return dictionary
    }
    
    func createImageUploadParam(base64Data: String) -> Dictionary<String,String>{
        let dictionary = self.createImageUploadDictionary(base64Data)
        return dictionary
    }
    
    func createBase64String(image : UIImage) -> String{
        let imageData:NSData = UIImageJPEGRepresentation(image,1.0)! as NSData
        return self.createBase64String(imageData)
    }
    
    func createBase64(image :UIImage) -> NSData{
        return UIImageJPEGRepresentation(image,1.0)! as NSData
    }
    
    func createBase64String(data : NSData) -> String{
        let option = NSDataBase64EncodingOptions.init(rawValue: 0)
        let strBase64 : String = data.base64EncodedStringWithOptions(option)
        return strBase64
    }
    
    func createImageUploadDictionary(string: String) -> Dictionary<String,String>{
        
        var result = [String: String]()
        result["data"] = string
        result["contentType"] = "image/jpeg"
        result["dispatch"] = "s"
        return result;
    }
    
}
