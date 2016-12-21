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
        self.service = BoxService.init()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAuthenticate() {
        let exp = expectationWithDescription("Some Expectation To Be Filled")
        self.service?.authenticate(){
            (user,error) in
            self.validateResults(user, error: error)
            exp.fulfill()
        }
        waitForExpectationsWithTimeout(60, handler: { error in
            XCTAssertNil(error, "Error")})
    
    }
    
    func testUploadWithNSData() {
        
        let exp = expectationWithDescription("Some Expectation To Be Filled")
        //1)First Authenticate
        self.service?.authenticate(){
            (user,error) in
            self.validateResults(user, error: error)
            let bundle = NSBundle(forClass: self.dynamicType)
            let img = UIImage(named: "testImg.jpg", inBundle: bundle, compatibleWithTraitCollection: nil)
            let imgData:NSData = UIImageJPEGRepresentation(img!, 1.0)! as NSData
            //2)Second Upload After Being Authenticated
            self.service?.upload(imgData){
                (file,error) in
                //3)Assert After Files being uploaded
                self.validateResults(file, error: error)
                exp.fulfill()
            }
        }
        waitForExpectationsWithTimeout(60, handler: { error in
            XCTAssertNil(error, "Error")})
    }
    
    func validateResults(object : AnyObject?, error : NSError?){
        if error != nil {
            print(error)
        }
        XCTAssertNotNil(object)
        XCTAssertNil(error)
    }
}
