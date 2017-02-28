//
//  ImageUtilTest.swift
//  IBMCaptureSDK-Sample
//
//  Created by David Kwok Ho Chan on 2/20/17.
//  Copyright © 2017 Future Workshops. All rights reserved.
//
import XCTest
@testable import IBMCaptureSDK_Sample

class ImageUtilTest: XCTestCase{
    
    var util = ImageUtil()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testCreateSmallFileSize(){
        
        let image = self.getUIImage()
        let originalImageData = UIImagePNGRepresentation(image)! as NSData
        let expectedSize = 1000.0
        print("original size" + String(util.getDataSize(originalImageData)))
        let fileSize = util.getDataSize(util.createSmallFileSize(image, size: expectedSize))
        print("expected Size" + String(expectedSize))
        print("actual size" + String(fileSize))
        XCTAssertLessThanOrEqual(fileSize, expectedSize)
    }

    func getUIImage() -> UIImage{
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let img = UIImage(named: "UK_check", inBundle: bundle, compatibleWithTraitCollection: nil)
        return img!
        
    }
    
}
