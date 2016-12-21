//
//  BoxService.swift
//  IBMCaptureSDK-Sample
//
//  Created by davix on 12/15/16.
//  Copyright © 2016 Future Workshops. All rights reserved.
//

import Foundation
import BoxContentSDK

class BoxService{
    
    let client_id = "6rassr1x5u0zic78ra1r7n83grn0v5yd"
    let client_secret = "4Y9RpnpW2YVFpPwYytI0wLIEQWO9r6y5"
    var client : BOXContentClient?
    
    init() {
    }
    
    func authenticate(completion: ((BOXUser!, NSError!) -> Void)!){
     
        BOXContentClient.setClientID(self.client_id, clientSecret: self.client_secret)
        self.client = BOXContentClient.defaultClient()
        self.client?.authenticateWithCompletionBlock(){
            (user, error) in
            completion(user,error)
        }
    }
    
    func authenticateWithNewUser(completion: ((BOXUser!, NSError!) -> Void)!){
        
        //:TODO Implement
        BOXContentClient.setClientID(self.client_id, clientSecret: self.client_secret)
        self.client = BOXContentClient.clientForNewSession()
        self.client?.authenticateWithCompletionBlock(){
            (user, error) in
            completion(user,error)
        }
    
    }
    
    func upload(data: NSData, completion: ((BOXFile!, NSError!) -> Void)!){
        
        let client = BOXContentClient.defaultClient()
        let folderID = "0"
        let fileName = "File Name"
        let request = client.fileUploadRequestToFolderWithID(folderID, fromData: data, fileName: fileName)
        let progressBlock : BOXProgressBlock? = { (a,b) in }
        request.performRequestWithProgress(progressBlock, completion: completion)
        
    }
    
    func upload(filePath: String, completion: ((BOXUser!, NSError!) -> Void)!){
        //Todo Implement
        completion(nil,nil)
        
//        Upload from a local file:
//        
//        BOXContentClient *contentClient = [BOXContentClient defaultClient];
//        NSString *localFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.jpg"];
//        BOXFileUploadRequest *uploadRequest = [contentClient fileUploadRequestToFolderWithID:BoxAPIFolderIDRoot fromLocalFilePath:localFilePath];
//        
//        // Optional: By default the name of the file on the local filesystem will be used as the name on Box. However, you can
//        // set a different name for the file by configuring the request:
//        uploadRequest.fileName = @"A different file name.jpg";
//        
//        [uploadRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
//        // Update a progress bar, etc.
//        } completion:^(BOXFile *file, NSError *error) {
//        // Upload has completed. If successful, file will be non-nil; otherwise, error will be non-nil.
//        }];

    }

}
