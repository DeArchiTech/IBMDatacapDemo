//
//  PodData.swift
//  IBMCaptureSDK-Sample
//
//  Created by David Kwok Ho Chan on 1/13/17.
//  Copyright © 2017 Future Workshops. All rights reserved.
//
import Foundation
import IBMCaptureSDK
import IBMCaptureUISDK
import UIKit

public class PodData : NSObject {

    public var customerSalesOrder: ICPMRZField
    public var customerId: ICPMRZField
    
    public init(customerSalesOrder: ICPMRZField, customerId: ICPMRZField){
        self.customerSalesOrder = customerSalesOrder
        self.customerId = customerId
    }
    
}








