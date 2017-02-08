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
    }
    
    func createFields() -> [ICPField]{
        return []
    }

}
