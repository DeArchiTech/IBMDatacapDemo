//
//  LoginViewControllerTest.swift
//  IBMCaptureSDK-Sample
//
//  Created by David Kwok Ho Chan on 12/20/16.
//  Copyright © 2016 Future Workshops. All rights reserved.
//
import XCTest
@testable import IBMCaptureSDK_Sample

class BoxLoginViewControllerTest: XCTestCase{
    
    var vc : BoxLoginViewController?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAuthenticate() {
        let exp = expectationWithDescription("Some Expectation To Be Filled")
        self.vc = BoxLoginViewController()
        self.vc?.service = BoxService.init()
        self.vc?.authenticate(){
            (user,error) in
            XCTAssertNotNil(user)
            XCTAssertNil(error)
            exp.fulfill()
        }
        waitForExpectationsWithTimeout(60, handler: { error in
            XCTAssertNil(error, "Error")
        })
    }
//    
//    func testHandleAuthenticateResponse(){
//    
//        //If Error is not nil, presents error dialog
//        //Else present success dialog
//        
//    }
    
}

