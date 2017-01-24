//
//  IBMIDRegHelper.swift
//  IBMCaptureSDK-Sample
//
//  Created by David Kwok Ho Chan on 1/23/17.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import BoxContentSDK

class IBMIDRegHelper{

    var service : BoxService?
    
    init(service : BoxService){
        self.service = service
    }
    
    func addMetaData(fileID : String, dictionary : Dictionary<String, String>, completionBlock : BOXMetadataBlock){
        
        self.service?.createMetadataOnFile(fileID){
            (data, error) in
            let dictionary : Dictionary<String, String> = Dictionary<String, String>()
            self.service?.updateMetaData(fileID, dictionary: dictionary){
                (data, error) in
                completionBlock(data,error)
            }
        }
    }
    
}
