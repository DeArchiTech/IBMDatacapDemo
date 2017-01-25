//
//  BoxServiceFolderTest.swift
//  IBMCaptureSDK-Sample
//
//  Created by David Kwok Ho Chan on 1/23/17.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

import XCTest
import BoxContentSDK
@testable import IBMCaptureSDK_Sample

class BoxServiceFolderTest: XCTestCase {
    
    var service : BoxService?
    var folderID = "0"
    let podFolder = "16978324036"
    
    override func setUp() {
        super.setUp()
        self.service = BoxService.init()
        self.folderID = self.podFolder
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReadFolderWithName() {
        
        let exp = expectationWithDescription("Some Expectation To Be Filled")
        let folderName = BoxServiceUtil().getFolderName()
        //1)First Authenticate
        self.service?.authenticate(){
            (user,error) in
            self.validateResults(user, error: error)
            self.service?.createFolder(folderName){
                (folder,error) in
                self.validateResults(folder, error: error)
                print(self.folderID)
                self.service?.findFolderWithName(self.folderID, folderName:folderName){
                    (folder) in
                    XCTAssertNotNil(folder)
                    exp.fulfill()
                }
            }
        }
        waitForExpectationsWithTimeout(60, handler: { error in
            XCTAssertNil(error, "Error")})
        
    }
    
    func testReadFolder(){
        
        let exp = expectationWithDescription("Some Expectation To Be Filled")
        //1)First Authenticate
        self.service?.authenticate(){
            (user,error) in
            self.validateResults(user, error: error)
            self.service?.readFolder(){
                (items, error) in
                self.validateResults(items, error: error)
            }
        }
        waitForExpectationsWithTimeout(60, handler: { error in
            XCTAssertNil(error, "Error")})
    }
    
    func testCreateFolder(){
        
        let exp = expectationWithDescription("Some Expectation To Be Filled")
        //1)First Authenticate
        self.service?.authenticate(){
            (user,error) in
            self.validateResults(user, error: error)
            let folderName = BoxServiceUtil().getFolderName()
            self.service?.createFolder(folderName){
                (folder,error) in
                self.validateResults(folder, error: error)
                exp.fulfill()
            }
        }
        waitForExpectationsWithTimeout(60, handler: { error in
            XCTAssertNil(error, "Error")})
        
    }
    
    func testFileInNewFolder(){
        
        let exp = expectationWithDescription("Some Expectation To Be Filled")
        //1)First Authenticate
        self.service?.authenticate(){
            (user,error) in
            self.validateResults(user, error: error)
            let folderName = BoxServiceUtil().getFolderName()
            self.service?.createFolder(folderName){
                (folder,error) in
                self.validateResults(folder, error: error)
                self.folderID = BoxServiceUtil().getFolderID(folder)
                self.service?.upload(self.getImageData(), folderID: self.folderID, fileName: BoxServiceUtil().getFileName()){
                    (file,error) in
                    //3)Assert After Files being uploaded
                    self.validateResults(file, error: error)
                    exp.fulfill()
                }
            }
        }
        waitForExpectationsWithTimeout(60, handler: { error in
            XCTAssertNil(error, "Error")})
        
    }
    
    func getImageData() -> NSData{
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let img = UIImage(named: "testImg.jpg", inBundle: bundle, compatibleWithTraitCollection: nil)
        let imgData:NSData = UIImageJPEGRepresentation(img!, 1.0)! as NSData
        return imgData
        
    }
    
    func validateResults(object : AnyObject?, error : NSError?){
        if error != nil {
            print(error)
        }
        XCTAssertNotNil(object)
        XCTAssertNil(error)
    }
    
}
