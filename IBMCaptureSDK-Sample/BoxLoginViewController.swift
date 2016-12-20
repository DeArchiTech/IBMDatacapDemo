//
//  BoxLoginViewController.swift
//  IBMCaptureSDK-Sample
//
//  Created by David Kwok Ho Chan on 12/20/16.
//  Copyright © 2016 Future Workshops. All rights reserved.
//

import Foundation
import BoxContentSDK

class BoxLoginViewController : UIViewController{
    
    var service : BoxService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.service = BoxService.init()
        self.authenticate(){
            (user,error) in
            self.handleAuthenticateResponse(user, error: error)
        }
    }
    
    func authenticate(completion: ((BOXUser!, NSError!) -> Void)!){
        self.service?.authenticate(){
            (user, error) in
            completion(user,error)
        }
    }
    
    func handleAuthenticateResponse(user : BOXUser?, error : NSError?){
        print("User Logs In Successfully")
    }
    
}
