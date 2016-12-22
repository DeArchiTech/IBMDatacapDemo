//
//  BoxUploadViewController.swift
//  IBMCaptureSDK-Sample
//
//  Created by David Kwok Ho Chan on 12/21/16.
//  Copyright © 2016 Future Workshops. All rights reserved.
//

import Foundation
import BoxContentSDK

class BoxUploadViewController : UIViewController{
    
    var service : BoxService?
    let folderID = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.service = BoxService.init()
    }
    
    func upload(data : NSData, fileName: String, completion : ((BOXFile!, NSError!) -> Void)!){
        //Todo Implement
        self.service?.upload(data, folderID: folderID, fileName: fileName){
            (object, error) in
            completion(object,error)
        }
    }
    
}
