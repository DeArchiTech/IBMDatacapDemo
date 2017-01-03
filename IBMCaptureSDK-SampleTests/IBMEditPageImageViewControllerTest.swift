//
//  IBMEditPageImageViewController.swift
//  IBMCaptureSDK-Sample
//
//  Created by David Kwok Ho Chan on 12/22/16.
//  Copyright © 2016 Future Workshops. All rights reserved.
//
import XCTest
import BoxContentSDK
@testable import IBMCaptureSDK_Sample

class IBMEditPageImageViewControllerTest : XCTestCase{

    var vc : IBMEditPageImageViewController?
    var service : BoxService = BoxService.init()
    
    override func setUp() {
        super.setUp()
        var storyboard: UIStoryboard = UIStoryboard(name: "IBMStoryboard", bundle: nil)
        self.vc = storyboard.instantiateViewControllerWithIdentifier("IBMEditPageImageViewController") as! IBMEditPageImageViewController
        self.vc!.loadView()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testUploadImage(){
        
        let exp = expectationWithDescription("Some Expectation To Be Filled")
        self.service.authenticate(){
            (user, error) in
            XCTAssertNotNil(user)
            XCTAssertNil(error)
            let data : NSData = self.getImageData()
            let fileName : String = self.getFileName()
            self.vc?.uploadImage(data, fileName: fileName){
                (file, error) in
                XCTAssertNotNil(file)
                XCTAssertNil(error)
                exp.fulfill()
            }
        }
        waitForExpectationsWithTimeout(60, handler: { error in
            XCTAssertNil(error, "Error")
        })
    }
    
    func testHandleUploadResponse(){
        let file : BOXFile? = nil
        let error : NSError? = nil
        self.vc?.handleUploadResponse(file, error: error)
    }
    
    func testPresentsSuccess(){
        self.vc?.presentsSuccess(nil)
    }
    
    func testPresentsFailure(){
        self.vc?.presentsFailure(nil)
    }
    
    func testUpload(){
        self.vc?.uploadAction(self.getFileName())
    }
    
    func testApplyFilter(){
        let bundle = NSBundle(forClass: self.dynamicType)
        let img = UIImage(named: "testImg.jpg", inBundle: bundle, compatibleWithTraitCollection: nil)
        let result = self.vc?.applyFilterCode(img!)
        XCTAssertTrue(result!)
    }
    
    func testPresentsPopup(){
        let result = self.vc?.addPopUp()
        XCTAssertTrue(result!)
    }
    
    func testGetDateString(){
        
        let result : String = (self.vc?.getDateString())!
        print("The test string is")
        print(result)
        print("That is the test string")
        let count = result.characters.count
        XCTAssert(count > 0)
        
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
