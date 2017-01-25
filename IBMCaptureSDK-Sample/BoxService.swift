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
    let folderID = "16978324036"
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
//        var task : [AnyObject] = [self.createMetaDataUpdateTask()]
        var task = []
        let metaDataRequest = client.metadataCreateRequestWithFileID(fileID, scope: "enterprise", template: "poddemo", tasks: task as [AnyObject])
        metaDataRequest.performRequestWithCompletion(completionBlock)
        
    }
    
    func createMetaDataUpdateTask() ->BOXMetadataUpdateTask{
        
        let task : BOXMetadataUpdateTask = BOXMetadataUpdateTask.init(operation: BOXMetadataUpdateADD, path: "/checked", value: "true")
        return task
        
    }
    
    func readFolder(completionBlock : BOXItemsBlock){
        
        let client = BOXContentClient.defaultClient()
        let request : BOXFolderItemsRequest = client.folderItemsRequestWithID("0")
        request.performRequestWithCompletion(completionBlock)
        
    }
    
    func readFolder(folderID : String, completionBlock : BOXItemsBlock){
        
        let client = BOXContentClient.defaultClient()
        let request : BOXFolderItemsRequest = client.folderItemsRequestWithID(folderID)
        request.performRequestWithCompletion(completionBlock)
        
    }
    
    func updateMetaData(fileID : String, dictionary : Dictionary<String,String>, completionBlock : BOXMetadataBlock){
        
        let client = BOXContentClient.defaultClient()
        var tasks : [AnyObject] = []
        for key in dictionary.keys{
            //We need the "/" for a valid JSON pointer
            let task : BOXMetadataUpdateTask = BOXMetadataUpdateTask.init(operation: BOXMetadataUpdateADD, path: "/"+key, value: dictionary[key])
            tasks.append(task)
        }
        let request : BOXMetadataUpdateRequest = client.metadataUpdateRequestWithFileID(fileID, scope: "enterprise", template: "poddemo", updateTasks: tasks)
        request.performRequestWithCompletion(completionBlock)
        
    }
    
    func createFolder(folderName : String, completionBlock : BOXFolderBlock){
        
        let client = BOXContentClient.defaultClient()
        let request : BOXFolderCreateRequest = client.folderCreateRequestWithName(folderName, parentFolderID: self.folderID)
        request.performRequestWithCompletion(completionBlock)
    
    }
    
    func findFolderWithName(folderID: String, folderName: String, completion: ((AnyObject!) -> Void)!){

        self.readFolder(folderID){
            (items, error) in
            let folder = self.getFolderWithName(folderName, items: items)
            completion(folder)
        }
    }
    
    func getFolderWithName(folderName: String, items: [AnyObject]) -> AnyObject?{
        
        for item in items{
            if let folder = item as? BOXFolder {
                if(folder.name == folderName){
                    return item
                }
            }
        }
        return nil

    }

}
