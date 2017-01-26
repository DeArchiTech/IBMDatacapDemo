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
    public var owner: ICPMRZField
    public var customerName: ICPMRZField
    public var deliveryAddress: ICPMRZField
    public var ppmShipment: ICPMRZField
    public var carrier: ICPMRZField
    public var shipmentDate: ICPMRZField
    public var facture: ICPMRZField
    
    public init(customerSalesOrder: ICPMRZField, customerId: ICPMRZField, owner: ICPMRZField, customerName: ICPMRZField, deliveryAddress: ICPMRZField, ppmShipment: ICPMRZField, carrier: ICPMRZField, shipmentDate: ICPMRZField, facture : ICPMRZField){
        self.customerSalesOrder = customerSalesOrder
        self.customerId = customerId
        self.owner = owner
        self.customerName = customerName
        self.deliveryAddress = deliveryAddress
        self.ppmShipment = ppmShipment
        self.carrier = carrier
        self.shipmentDate = shipmentDate
        self.facture = facture
    }
    
    func setUpMockData(){
        self.customerName = ICPMRZField.init(value: "Labatt", confidence: 1, checked: true)
        self.facture = ICPMRZField.init(value: "0007518729", confidence: 1, checked: true)
    }
}
