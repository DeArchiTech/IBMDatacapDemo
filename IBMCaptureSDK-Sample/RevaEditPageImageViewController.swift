//
//  RevaEditPageImageViewController.swift
//  IBMCaptureSDK-Sample
//
//  Created by David Kwok Ho Chan on 12/21/16.
//  Copyright © 2016 Future Workshops. All rights reserved.
//

import Foundation
import BoxContentSDK

class RevaEditPageImageViewController : IBMEditPageImageViewController{
    
    var service : BoxService?
    var folderID = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.service = BoxService.init()
    }
    
    func uploadImage(data : NSData, fileName : String){
        self.service?.upload(data, folderID: self.folderID, fileName: fileName){
            (file, error) in
            self.handleUploadResponse(file, error: error)
        }
    }
    
    func handleUploadResponse(file : BOXFile, error: NSError){
            
    }
}
