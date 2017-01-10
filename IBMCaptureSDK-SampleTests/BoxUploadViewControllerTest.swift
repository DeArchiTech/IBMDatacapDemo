//
//  BoxUploadViewControllerTest.swift
//  IBMCaptureSDK-Sample
//
//  Created by David Kwok Ho Chan on 12/21/16.
//  Copyright © 2016 Future Workshops. All rights reserved.
//
import XCTest
import BoxContentSDK
@testable import IBMCaptureSDK_Sample

class BoxUploadViewControllerTest : XCTestCase{
    
    var vc : BoxUploadViewController?
    var service : BoxService?
    
    override func setUp() {
        super.setUp()
        self.vc = BoxUploadViewController()
        self.service = BoxService.init()
        self.vc?.service = self.service
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testUpload() {
        let exp = expectationWithDescription("Some Expectation To Be Filled")
        //1)First Authenticate
        self.service?.authenticate(){
            (user,error) in
            self.validateResults(user, error: error)
            self.vc?.upload(self.getImageData(), fileName: self.getFileName()){
                (object,error) in
                self.validateResults(object, error: error)
                exp.fulfill()
            }
        }
        waitForExpectationsWithTimeout(60, handler: { error in
            XCTAssertNil(error, "Error")})
    }
    
    //Helper Methods 
    
    func validateResults(object : AnyObject?, error : NSError?){
        if error != nil {
            print(error)
        }
        XCTAssertNotNil(object)
        XCTAssertNil(error)
    }
    
    func getFileName() -> String{
        
        return "Le File Name" + String(arc4random_uniform(100))
        
    }
    
    func getImageData() -> NSData{
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let img = UIImage(named: "testImg.jpg", inBundle: bundle, compatibleWithTraitCollection: nil)
        let imgData:NSData = UIImageJPEGRepresentation(img!, 1.0)! as NSData
        return imgData
        
    }

}
