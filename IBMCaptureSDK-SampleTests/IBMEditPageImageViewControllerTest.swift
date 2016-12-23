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
    }
    
    func testHandleUploadResponse(){
        let file : BOXFile? = nil
        let error : NSError? = nil
        self.vc?.handleUploadResponse(file, error: error)
    }
    
    func testPresentsSuccess(){
        self.vc?.presentsSuccess()
    }
    
    func testPresentsFailure(){
        self.vc?.presentsFailure()
    }
    
}
