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
    
    func upload(data: NSData, folderID: String, fileName: String, completion: ((BOXFile!, NSError!) -> Void)!){
        
        let client = BOXContentClient.defaultClient()
        //Please remember to authenticate
        //Todo: Add A Guard Statement
        let request = client.fileUploadRequestToFolderWithID(folderID, fromData: data, fileName: fileName)
        let progressBlock : BOXProgressBlock? = { (a,b) in }
        request.performRequestWithProgress(progressBlock, completion: completion)
        
    }
    
    func getBoxTemplates(completionBlock : BOXMetadataTemplatesBlock){
        
        let client = BOXContentClient.defaultClient()
        let metadataTemplateRequest : BOXMetadataTemplateRequest = client.metadataTemplatesInfoRequest()
        metadataTemplateRequest.performRequestWithCompletion(completionBlock)
        
    }
    
    func getSpecificTemplate(completionBlock : BOXMetadataTemplatesBlock){
        
        let client = BOXContentClient.defaultClient()
        let scope = "global"
        let templateString = "poddemo"
        let request = client.metadataTemplateInfoRequestWithScope(scope, template: templateString)
        request.performRequestWithCompletion(completionBlock)
        
    }
    
    func getTemplate(array : [AnyObject]) -> BOXMetadataTemplate{
        
        return array.first as! BOXMetadataTemplate
        
    }
    
    func createMetadataOnFile(fileID : String, completionBlock : BOXMetadataBlock){

        let client = BOXContentClient.defaultClient()
        var task : [AnyObject] = [self.createMetaDataUpdateTask()]
        task = []
        let metaDataRequest = client.metadataCreateRequestWithFileID(fileID, scope: "enterprise", template: "poddemo", tasks: task)
        metaDataRequest.performRequestWithCompletion(completionBlock)
        
    }
    
    func createMetaDataUpdateTask() ->BOXMetadataUpdateTask{
        
        let dict : [String : AnyObject] = ["checked":"true"]
        let task : BOXMetadataUpdateTask = BOXMetadataUpdateTask.init()
        task.operation = BOXMetadataUpdateADD
        task.setValuesForKeysWithDictionary(dict)
        return task
        
    }
    
    func readFolder(completionBlock : BOXItemsBlock){
        
        let client = BOXContentClient.defaultClient()
        let request : BOXFolderItemsRequest = client.folderItemsRequestWithID("0")
        request.performRequestWithCompletion(completionBlock)
        
    }
    
    func updateMetaData(fileID : String, completionBlock : BOXMetadataBlock){
        
        let client = BOXContentClient.defaultClient()
        let task : BOXMetadataUpdateTask = BOXMetadataUpdateTask.init(operation: BOXMetadataUpdateADD, path: "/checked/", value: "true")
        let request : BOXMetadataUpdateRequest = client.metadataUpdateRequestWithFileID(fileID, template: "poddemo", updateTasks: [task])
        request.performRequestWithCompletion(completionBlock)
        
    }

}
