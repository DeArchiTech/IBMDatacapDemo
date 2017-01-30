//
//  BoxServiceUtilTest.swift
//  IBMCaptureSDK-Sample
//
//  Created by David Kwok Ho Chan on 1/24/17.
//  Copyright © 2017 Future Workshops. All rights reserved.
//
import XCTest
import BoxContentSDK
@testable import IBMCaptureSDK_Sample

class BoxServiceUtilTest: XCTestCase {
    
    var util : BoxServiceUtil?
    
    override func setUp() {
        super.setUp()
        self.util = BoxServiceUtil.init()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFileNameEndsWithJPG(){
        
        let fileName = self.util?.getFileName()
        XCTAssertTrue(fileName!.hasSuffix(".jpg"))
    }
    
    func testGetFolderName(){
        
        var dictionary : Dictionary<String,String> = Dictionary<String,String>()
        let leetCustomerName = "Le Customer name"
        dictionary["customername"] = leetCustomerName
        XCTAssertEqual(self.util?.getFolderName(dictionary), leetCustomerName)
    }
    
}
