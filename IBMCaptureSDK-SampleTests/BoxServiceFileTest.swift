//
//  IBMCaptureSDK_SampleTests.swift
//  IBMCaptureSDK-SampleTests
//
//  Created by davix on 12/15/16.
//  Copyright © 2016 Future Workshops. All rights reserved.
//

import XCTest
import BoxContentSDK
@testable import IBMCaptureSDK_Sample

class BoxServiceFileTest: XCTestCase {
    
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
            //2)Second Upload After Being Authenticated
            self.service?.upload(self.getImageData(), folderID: self.folderID, fileName: self.getFileName()){
                (file,error) in
                //3)Assert After Files being uploaded
                self.validateResults(file, error: error)
                exp.fulfill()
            }
        }
        waitForExpectationsWithTimeout(60, handler: { error in
            XCTAssertNil(error, "Error")})
    }
    
    func testGetTemplates() {
        
        let exp = expectationWithDescription("Some Expectation To Be Filled")
        //1)First Authenticate
        self.service?.authenticate(){
            (user,error) in
            self.validateResults(user, error: error)
            //2)Second Upload After Being Authenticated
            self.service?.getBoxTemplates(){
                (templates,error) in
                self.validateResults(templates, error: error)
                exp.fulfill()
            }
        }
        waitForExpectationsWithTimeout(60, handler: { error in
            XCTAssertNil(error, "Error")})
        
    }
    
    func testGetSpecificTemplate() {
        
        let exp = expectationWithDescription("Some Expectation To Be Filled")
        //1)First Authenticate
        self.service?.authenticate(){
            (user,error) in
            self.validateResults(user, error: error)
            //2)Second Upload After Being Authenticated
            self.service?.getSpecificTemplate(){
                (template,error) in
                self.validateResults(template, error: error)
                exp.fulfill()
            }
        }
        waitForExpectationsWithTimeout(60, handler: { error in
            XCTAssertNil(error, "Error")})
        
    }
    
    func testCreateMetadataOnFile() {
        
        let exp = expectationWithDescription("Some Expectation To Be Filled")
        //1)First Authenticate
        self.service?.authenticate(){
            (user,error) in
            self.validateResults(user, error: error)
            self.service?.upload(self.getImageData(), folderID: self.folderID, fileName: self.getFileName()){
                (file,error) in
                //3)Assert After Files being uploaded
                self.service?.createMetadataOnFile(self.getFileID(file)){
                    (metaData,error) in
                    print(self.getMetaDataID(metaData))
                    self.validateResults(metaData, error: error)
                    exp.fulfill()
                }
            }
        }
        waitForExpectationsWithTimeout(60, handler: { error in
            XCTAssertNil(error, "Error")})
        
    }
    
    func testUpdateMetaDataForFile(){
        
        let exp = expectationWithDescription("Some Expectation To Be Filled")
        //1)First Authenticate
        self.service?.authenticate(){
            (user,error) in
            self.validateResults(user, error: error)
            self.service?.upload(self.getImageData(), folderID: self.folderID, fileName: self.getFileName()){
                (file,error) in
                //3)Assert After Files being uploaded
                self.service?.createMetadataOnFile(self.getFileID(file)){
                    (metaData,error) in
                    self.service?.updateMetaData(file.modelID){
                        (item, error) in
                        self.validateResults(metaData, error: error)
                        exp.fulfill()
                    }
                }
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
    
    func getFileName() -> String{
        
        return BoxServiceUtil().getFileName()
        
    }
    
    func getImageData() -> NSData{
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let img = UIImage(named: "testImg.jpg", inBundle: bundle, compatibleWithTraitCollection: nil)
        let imgData:NSData = UIImageJPEGRepresentation(img!, 1.0)! as NSData
        return imgData
        
    }
    
    func printFileID(file : BOXFile) {
        print(file.modelID)
        print(file.sequenceID)
    }

    func printMetaDataInfo(metaData : BOXMetadata){
        print(metaData.JSONData)
        print(metaData.info)
    }
    
    func getFileID(file :BOXFile) -> String{
        return file.modelID!
    }
    
    func getMetaDataID(metaData: BOXMetadata) -> String{
        return metaData.JSONData["$id"] as! String
    }
}
