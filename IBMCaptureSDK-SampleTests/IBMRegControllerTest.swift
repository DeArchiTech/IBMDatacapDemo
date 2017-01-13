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

class IBMIDRecognitionViewController: XCTestCase{

    var vc : IBMIDRecognitionViewController?
    
    override func setUp() {
        super.setUp()
        var storyboard: UIStoryboard = UIStoryboard(name: "PODDemo", bundle: nil)
        self.vc = storyboard.instantiateViewControllerWithIdentifier("recognitionViewController") as! IBMIDRecognitionViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRegconize(){
    }

}
