//
//  IBMCaptureSDK_SampleTests.swift
//  IBMCaptureSDK-SampleTests
//
//  Created by davix on 12/15/16.
//  Copyright © 2016 Future Workshops. All rights reserved.
//

import XCTest
@testable import IBMCaptureSDK_Sample

class BoxServiceTest: XCTestCase {
    
    var service : BoxService?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAuthenticate() {
        self.service = BoxService.init()
        let exp = expectationWithDescription("Some Expectation To Be Filled")
        self.service?.authenticate(){
            (user,error) in
            XCTAssertNotNil(user)
            XCTAssertNil(error)
            exp.fulfill()
        }
        waitForExpectationsWithTimeout(60, handler: { error in
            XCTAssertNil(error, "Error")
        })
    
    }
    
    func testAuthenticateWithNewUser() {
        self.service = BoxService.init()
        let exp = expectationWithDescription("Some Expectation To Be Filled")
        self.service?.authenticateWithNewUser(){
            (user,error) in
            XCTAssertNotNil(user)
            XCTAssertNil(error)
            exp.fulfill()
        }
        waitForExpectationsWithTimeout(60, handler: { error in
            XCTAssertNil(error, "Error")
        })
    }
}
