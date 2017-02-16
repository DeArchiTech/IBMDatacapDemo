//
//  CustomerRepositoryTest.swift
//  IBMCaptureSDK-Sample
//
//  Created by David Kwok Ho Chan on 1/23/17.
//  Copyright © 2017 Future Workshops. All rights reserved.
//
import XCTest
@testable import IBMCaptureSDK_Sample

class OCRserviceTest: XCTestCase{
    
    var service : OCRservice?
    
    override func setUp() {
        super.setUp()
        self.service = OCRservice.init()
        self.service!.img = self.getTestImg()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPerformOcr(){
        
        let exp = expectationWithDescription("Some Expectation To Be Filled")
        self.service?.performOCR(){
            (object) in
            XCTAssertNotNil(object)
            print(object)
            print(object["ParsedResults"])
            exp.fulfill()
        }
        waitForExpectationsWithTimeout(60, handler: { error in
            XCTAssertNil(error, "Error")})
        
    }
    
    func testCreateParam(){
        
        let param = self.service?.createParam()
        XCTAssertNotNil(param)
        
    }
    
    func testGetImgString() {
        
        let string = self.service?.createBase64String()
        XCTAssertNotNil(string)
        
    }
    
    func getTestImg() -> UIImage{
        
        let bundle = NSBundle(forClass: self.dynamicType)
        return UIImage(named: "metroClearImg.jpg", inBundle: bundle, compatibleWithTraitCollection: nil)!
        
    }
}
