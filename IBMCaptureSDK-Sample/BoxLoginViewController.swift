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
    
    func upload(filePath: String, completion: ((BOXUser!, NSError!) -> Void)!){
        //Todo Implement
        completion(nil,nil)
    }
    
    func handleAuthenticateResponse(user : BOXUser?, error : NSError?) -> Bool{
        if error == nil{
            self.presentsSuccess()
        }else{
            self.presentsFailure()
        }
        return true
    }
    
    func presentsSuccess(){
        let message = "User has been authenticated"
        let alertController = UIAlertController(title: "Authentication Success", message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func presentsFailure(){
        let message = "User has not been authenticated"
        let alertController = UIAlertController(title: "Authentication Failed", message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
