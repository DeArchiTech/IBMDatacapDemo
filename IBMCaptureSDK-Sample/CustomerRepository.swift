//
//  CustomerRepository.swift
//  IBMCaptureSDK-Sample
//
//  Created by David Kwok Ho Chan on 1/23/17.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class CustomerRepository{
    
    var dictionary : [String: String]
    
    init(){
        self.dictionary = Dictionary<String,String>()
    }
    
    init(dictionary : Dictionary<String,String>){
        self.dictionary = dictionary
    }
    
    func getCustomerName(key : String) -> String{
        return self.dictionary[key]!
    }
    
}
