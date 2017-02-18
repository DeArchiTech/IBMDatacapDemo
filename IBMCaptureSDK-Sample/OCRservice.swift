//
//  OCRservice.swift
//  IBMCaptureSDK-Sample
//
//  Created by David Kwok Ho Chan on 2/15/17.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import Alamofire

class OCRservice{
    
    let endpoint = Constants.ocrEndPt
    let apiKey = Constants.ocrApiKey
    let language = "eng"
    
    func performOCR(image : UIImage, completion: ((AnyObject!) -> Void)!){

        Alamofire.upload(.POST, self.endpoint, multipartFormData: self.createMultipart(image), encodingCompletion: self.createCompletion(completion))
    }
    
    func createMultipart(image : UIImage) -> (MultipartFormData -> Void){
        
        let params = self.createParam()
        return {MultipartFormData in
            for (key, value) in params {
                MultipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
            }
            MultipartFormData.appendBodyPart(data: self.createImageData(image), name: "image", fileName: "metroClearImg.jpg", mimeType: "image/jpg")
        }
        
    }

    func createCompletion(completion: ((AnyObject!) -> Void)!) -> (Manager.MultipartFormDataEncodingResult -> Void)?{
        
        return { (result) in
            
            switch result {
            case Manager.MultipartFormDataEncodingResult.Success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                
                upload.responseJSON { response in
                    completion(response.result.value)
                }
                
            case Manager.MultipartFormDataEncodingResult.Failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    func createParam() -> [String : AnyObject]{
        
        var dictionary = [String : AnyObject]()
        dictionary["language"] = self.language
        dictionary["apikey"] = self.apiKey
        dictionary["isoverlayrequired"] = "false"
        return dictionary
        
    }
    
    func createImageData(img : UIImage) -> NSData{
        
        return ImageUtil().createBase64(img)
        
    }
    
}
