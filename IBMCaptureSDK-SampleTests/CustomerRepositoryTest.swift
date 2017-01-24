//
//  CustomerRepositoryTest.swift
//  IBMCaptureSDK-Sample
//
//  Created by David Kwok Ho Chan on 1/23/17.
//  Copyright © 2017 Future Workshops. All rights reserved.
//
import XCTest
import BoxContentSDK
@testable import IBMCaptureSDK_Sample

class CustomerRepositoryTest: XCTestCase{
    
    var repository : CustomerRepository?
    let customerID = "123"
    let customerName = "ABCDE"
        
    override func setUp() {
        super.setUp()
        var dictionary = Dictionary<String, String>()
        dictionary[self.customerID] = self.customerName
        self.repository = CustomerRepository.init(dictionary: dictionary)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCustomerLookUp(){
        
        let customerName = self.repository?.getCustomerName(self.customerID)
        XCTAssertEqual(customerName, self.customerName)
        
    }
    
}
