//
//  UploadVCProtocol.swift
//  IBMCaptureSDK-Sample
//
//  Created by David Kwok Ho Chan on 12/22/16.
//  Copyright © 2016 Future Workshops. All rights reserved.
//

import Foundation
import BoxContentSDK

protocol UploadVCProtocol{
    
    func uploadImage(data : NSData, fileName : String, completion: ((BOXFile!, NSError!) -> Void)!)
    
    func handleUploadResponse(file : BOXFile?, error: NSError?)
    
    func presentsSuccess(msg : String?)
    
    func presentsFailure(msg : String?)
    
    func getImageFile() -> UIImage?
    
}
