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
        self.client = BOXContentClient.clientForNewSession()
        self.client?.authenticateWithCompletionBlock(){
            (user, error) in
            completion(user,error)
        }
    }
    
    func authenticateWithNewUser(completion: ((BOXUser!, NSError!) -> Void)!){
        
        //:TODO Implement
        self.client?.authenticateInAppWithCompletionBlock(){
            (user, error) in
            completion(user,error)
        }
    
    }
    
}
