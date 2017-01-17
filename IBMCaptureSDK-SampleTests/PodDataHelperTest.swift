//
//  PodDataHelperTest.swift
//  IBMCaptureSDK-Sample
//
//  Created by David Kwok Ho Chan on 1/16/17.
//  Copyright © 2017 Future Workshops. All rights reserved.
//
import XCTest
import BoxContentSDK
@testable import IBMCaptureSDK_Sample

class PodDataHelperTest: XCTestCase{
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetCustomerSalesOrder(){
        
        let helper = PodDataHelper.init()
        let result = helper.getCustomerSalesOrder()
        let expected = "1229082"
        XCTAssertEqual(result, expected)
    }

    func testGetCustomerId(){
        
        let helper = PodDataHelper.init()
        let result = helper.getCustomerId()
        let expected = "2515167"
        XCTAssertEqual(result, expected)
    }
    
}
