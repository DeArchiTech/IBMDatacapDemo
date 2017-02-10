//
//  DatacapBackendService.swift
//  IBMCaptureSDK-Sample
//
//  Created by David Kwok Ho Chan on 2/8/17.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import BoxContentSDK
import IBMCaptureSDK
class DatacapBackendService{
    
    let serverUrl = "http://demo.revasolutions.com:8085"
    let userID = "admin"
    let password = "admin"
    let station = "1"
    
    init() {
    }
    
    func createPage(image : UIImage) -> ICPPage?{
        return nil
    }
    
    func authenticate(credentials : NSURLCredential) -> Bool{
        return false
    }
    
    func performOcrOnBackend() -> Bool {
        return false
        
        /**
         *  Recognize Page Fields
         *
         *  @param page                 The page with fields pre-populated with Position
         *  @param locale               Locale to be used by recognition. Default is (en-US)
         *  @param timeout              Timeout for transaction execution on server side.
         *  @param recognitionEngine    The engine to use for OCR recogntion on server side
         *  @param completionBlock      The completion block
         */
        
        /**
         *  Process Check by default. If the DCO at page level has the following variables (i.e. TransactionApplication,
         * TransactionRulesets, TransactionWorkflow), these will be used for the executeTransaction parameters.
         *
         *  @param checkFrontPage  ICPPage for the front of the check
         *  @param checkCountry    The country for the check
         *  @param keepAlive        Keep the connection alive, transaction will not be ended causing files to stay on server
         *  @param locale            Locale to be used by recognition. Default is (en-US)
         *  @param timeout         Timeout for transaction execution on server side.
         *  @param completionBlock The completion block
         */
        
        
        /**
         *  Recognize text in fields
         *
         *  @param field             The field with position to OCR
         *  @param locale            Locale to be used by recognition. Default is (en-US)
         *  @param timeout           Timeout for transaction execution on server side.
         *  @param recognitionEngine The OCR recognition engine to use
         *  @param completionBlock   The completion block
         */
    }
    
    func createFields() -> [ICPField] {
        return []
    }
    
    func createFactureField() -> ICPField? {
        //Might need to implement ICPField since its a protocol
        return nil
    }
    
    func createRect(x : Double, y: Double, width : Double, height: Double) -> ICPRect {
        let origin = ICPPoint.init(x: x, y: y)
        let size = ICPSize.init(width: width, height: height)
        return ICPRect.init(origin: origin, size: size)
    }
}
