//
//  LoginViewControllerTest.swift
//  IBMCaptureSDK-Sample
//
//  Created by David Kwok Ho Chan on 12/20/16.
//  Copyright © 2016 Future Workshops. All rights reserved.
//
import XCTest
import BoxContentSDK

@testable import IBMCaptureSDK_Sample

class BoxLoginViewControllerTest: XCTestCase{
    
    var vc : BoxLoginViewController?
    
    override func setUp() {
        super.setUp()
        self.vc = BoxLoginViewController()
        self.vc?.service = BoxService.init()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAuthenticate() {
        let exp = expectationWithDescription("Some Expectation To Be Filled")
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
    
    func testHandleAuthenticateResponse(){
    
        let user = BOXUser.init()
        var error : NSError? = nil
        //If Error is nil present success dialog
        var result = self.vc?.handleAuthenticateResponse(user, error: error)
        XCTAssertTrue(result!)
        //Else Error is not nil, presents error di!alog
        error = NSError.init(domain: "", code: 0, userInfo: [:])
        result = self.vc?.handleAuthenticateResponse(user, error: error)
        XCTAssertTrue(result!)
        
    }
    
    func testUpload() {
        let exp = expectationWithDescription("Some Expectation To Be Filled")
        let filePath = ""
        self.vc?.upload(filePath){
            (user,error) in
            XCTAssertNotNil(user)
            XCTAssertNil(error)
            exp.fulfill()
        }
        waitForExpectationsWithTimeout(60, handler: { error in
            XCTAssertNil(error, "Error")})
    }
    
    func testPresentsSuccess(){
        self.vc?.presentsSuccess()
    }
    
    func testPresentsFailure(){
        self.vc?.presentsFailure()
    }
    
}

