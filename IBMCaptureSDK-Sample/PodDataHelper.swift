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
    
    var podString: String = ""
    
    init(podString: String){
        super.init()
        self.podString = podString
    }
    
    func getCustomerSalesOrder() -> String {
        
        var result = ""
        for char in podString.unicodeScalars{
            let value = char.value
            if (value >= 48 && value <= 57){
                result.append(Character.init(char))
            }else{
                if result.characters.count > 0 {
                    break
                }
            }
        }
        return result
    }
    
    func getCustomerId() -> String {
        
        let nutsAndBolt = false
        var result = ""
        if nutsAndBolt {
            var firstSetOfLettersFound = false
            var firstSetOfDigitsFound = false
            var secondSetOfLetttersFound = false
            for char in podString.unicodeScalars{
                let value = char.value
                if (value >= 48 && value <= 57){
                    if !firstSetOfDigitsFound {
                        firstSetOfDigitsFound = true
                    }
                    if secondSetOfLetttersFound {
                        result.append(Character.init(char))
                    }
                }else{
                    if result.characters.count == 0 {
                        firstSetOfLettersFound = true
                    }
                    if firstSetOfLettersFound && firstSetOfDigitsFound{
                        secondSetOfLetttersFound = true
                    }
                }
            }
        }else{
            result = "Sample Customer Name"
        }
        return result
        
    }
    
    func getFactureNumber() -> String {
        
        let factureNum = OCRTextParser().parseText("FACTURE #", ocrText: self.podString)
        return factureNum
    }
    
    func getCustomerName() -> String {
        return "A Generic Custoemr Name"
    }
    
}
