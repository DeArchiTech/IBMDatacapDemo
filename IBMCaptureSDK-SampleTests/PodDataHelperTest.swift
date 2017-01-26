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
        
        let parsedString = "ABCDEASE1229082"
        let helper = PodDataHelper.init(podString: parsedString)
        let result = helper.getCustomerSalesOrder()
        let expected = "1229082"
        XCTAssertEqual(result, expected)
    }

    func testGetCustomerId(){
        
        let parsedString = "ABCDEASE1229082ABCDEASE2515167"
        let helper = PodDataHelper.init(podString: parsedString)
        let result = helper.getCustomerId()
        let expected = "2515167"
        print(result)
        XCTAssertEqual(result, expected)
    }
    
    func testGetFactureNumber(){
        
        let parsedString = "ABCDEASE1229082ABCDEASE2515167"
        let helper = PodDataHelper.init(podString: parsedString)
        XCTAssertNotNil(helper.getFactureNumber())
    }

    func testGetCustomerName(){
        
        let parsedString = "ABCDEASE1229082ABCDEASE2515167"
        let helper = PodDataHelper.init(podString: parsedString)
        XCTAssertNotNil(helper.getCustomerName())
        
    }
}
