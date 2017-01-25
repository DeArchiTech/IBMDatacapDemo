//
//  IBMRegControllerTest.swift
//  IBMCaptureSDK-Sample
//
//  Created by David Kwok Ho Chan on 1/12/17.
//  Copyright © 2017 Future Workshops. All rights reserved.
//
import XCTest
import BoxContentSDK
@testable import IBMCaptureSDK_Sample

class IBMIDRecognitionViewControllerTest: XCTestCase{

    var vc : IBMIDRecognitionViewController?
    var service : BoxService?
    var folderID = "0"
    let podFolder = "16978324036"
    
    override func setUp() {
        super.setUp()
        var storyboard: UIStoryboard = UIStoryboard(name: "PODDemo", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("recognitionViewController")
        self.vc = controller as! IBMIDRecognitionViewController
        self.service = BoxService.init()
        self.vc?.service = self.service
        self.folderID = self.podFolder
        self.vc?.folderID = self.folderID
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddMetaData(){
        
        let exp = expectationWithDescription("Some Expectation To Be Filled")
        //1)First Authenticate
        self.service?.authenticate(){
            (user,error) in
            self.validateResults(user, error: error)
            let fileName = BoxServiceUtil().getFileName()
            self.service?.upload(self.getImageData(), folderID: self.folderID, fileName: fileName){
                (file,error) in
                self.validateResults(fileName, error: error)
                //3)Assert After Files being uploaded
                self.vc?.addMetaData(file.modelID!, dictionary: self.createDictionary()){
                    (data, error) in
                    self.validateResults(data, error: error)
                    exp.fulfill()
                }
            }
        }
        waitForExpectationsWithTimeout(60, handler: { error in
            XCTAssertNil(error, "Error")})
        
    }
    
    func testGetFolderName(){
        
        let folderName = self.vc?.getFolderName(self.createDictionary())
        XCTAssertEqual(folderName, "aCustomerName")
        
    }
    
    //With No Folder On Box
    func testGetFolderFromBox(){
        
        let exp = expectationWithDescription("Some Expectation To Be Filled")
        //1)First Authenticate
        self.service?.authenticate(){
            (user,error) in
            self.validateResults(user, error: error)
            let folderName = BoxServiceUtil().getFolderName()
            self.vc?.getFolderFromBox(folderName){
                (folder) in
                XCTAssertNotNil(folder)
                exp.fulfill()
            }
        }
        waitForExpectationsWithTimeout(60, handler: { error in
            XCTAssertNil(error, "Error")})

    }

    //With Folder On Box
    func testGetFolderFromBoxTwo(){
        
        let exp = expectationWithDescription("Some Expectation To Be Filled")
        let folderName = BoxServiceUtil().getFolderName()
        //1)First Authenticate
        self.service?.authenticate(){
            (user,error) in
            self.validateResults(user, error: error)
            self.service?.createFolder(folderName){
                (folder, error) in
                self.vc?.getFolderFromBox(folderName){
                    (foundFolder) in
                    XCTAssertNotNil(foundFolder)
                    exp.fulfill()
                }
            }
        }
        waitForExpectationsWithTimeout(60, handler: { error in
            XCTAssertNil(error, "Error")})
        
    }

    func createDictionary() -> Dictionary<String,String>{
        
        var dictionary : Dictionary<String,String> = Dictionary<String,String>()
        dictionary["customerSalesOrder"] = "testString"
        dictionary["customerId"] = "testString"
        dictionary["checked"] = "testString"
        dictionary["customerName"] = "aCustomerName"
        return dictionary
        
    }
    
    func validateResults(object : AnyObject?, error : NSError?){
        if error != nil {
            print(error)
        }
        XCTAssertNotNil(object)
        XCTAssertNil(error)
    }

    func getImageData() -> NSData{
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let img = UIImage(named: "testImg.jpg", inBundle: bundle, compatibleWithTraitCollection: nil)
        let imgData:NSData = UIImageJPEGRepresentation(img!, 1.0)! as NSData
        return imgData
        
    }
    
}
