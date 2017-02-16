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
    let languyage = "fin"
    var img : UIImage?
    //var manager:
    
    func performOCR(completion: ((AnyObject!) -> Void)!){
        
        Alamofire.request(.POST, self.endpoint, parameters: self.createParam())//, encoding: URLEncoding.default)
        .validate()
        .responseJSON{ response in
            switch response.result{
            case Result.Success(let result):
                completion(result)
            case Result.Failure(let error):
                completion(error)
            }
        }
    }
    
    func getHeaders() -> [String:String]{
        let headers = [
            "Authorization": self.apiKey,
            "Accept": "application/json",
            "Accept-Language": "en-US",
//            "Content-Type": "application/vnd.emc.captiva+json; charset=utf-8"
        ]
        return headers
        
    }
    
    func createParam() -> [String : AnyObject]{
        
        var dictionary = [String : AnyObject]()
        dictionary["language"] = self.languyage
        dictionary["apikey"] = self.apiKey
        dictionary["isOverlayRequired"] = "True"
        dictionary["base64Image"] = self.createBase64String()
        return dictionary
        
    }
    
    func createBase64String() -> String{
        
        return ImageUtil().createBase64String(img!)
        
    }
    
}
