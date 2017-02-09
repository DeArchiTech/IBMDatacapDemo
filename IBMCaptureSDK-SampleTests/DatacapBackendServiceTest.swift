//
//  DatacapBackendServiceTest.swift
//  IBMCaptureSDK-Sample
//
//  Created by David Kwok Ho Chan on 2/8/17.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import XCTest
import BoxContentSDK
@testable import IBMCaptureSDK_Sample

class DatacapBackendServiceTest: XCTestCase {
    
    var service : DatacapBackendService?
    
    override func setUp() {
        super.setUp()
        self.service = DatacapBackendService.init()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreateRect(){
        let x = 50.0
        let y = 100.0
        let width = 125.0
        let height = 155.0
        let rect = self.service?.createRect(x, y: y, width: width, height: height)
        XCTAssertEqual(rect?.origin.x, x)
        XCTAssertEqual(rect?.origin.y, y)
    }
    
    func testCreatePage(){
        
    }
    
    func testAuthorization(){
        
    }
    
    func testPerformOcrOnBackEnd(){
        
    }
}
