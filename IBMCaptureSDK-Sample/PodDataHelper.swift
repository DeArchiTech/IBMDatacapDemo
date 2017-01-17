//
//  PodDataHelper.swift
//  IBMCaptureSDK-Sample
//
//  Created by David Kwok Ho Chan on 1/16/17.
//  Copyright © 2017 Future Workshops. All rights reserved.
//
import Foundation
import IBMCaptureSDK
import IBMCaptureUISDK
import UIKit

class PodDataHelper : NSObject{
    
    override init(){
        super.init()
    }
    
    func getCustomerSalesOrder() -> String {
        return "1229082"
    }
    
    func getCustomerId() -> String {
        return "2515167"
    }
}
