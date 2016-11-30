//
//  IBMMainTableViewController.swift
//  IBMCaptureSDK-Sample-Swift
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit
import IBMCaptureSDK
import IBMCaptureUISDK

class IBMMainTableViewController: UITableViewController {

    enum IBMMainTableSegue:String {
        case IBMMainToBatchSegue = "IBMMainToBatchSegue",
        IBMMainToImageEngineSegue = "IBMMainToImageEngineSegue",
        IBMMainToOCRSegue = "IBMMainToOCRSegue",
        IBMMainToBarcodeSegue = "IBMMainToBarcodeSegue",
        IBMMainToImageEditorSegue = "IBMMainToImageEditorSegue",
        IBMMainToCheckProcessing = "IBMMainToCheckProcessing",
        IBMMainToRecognizePageFields = "IBMMainToRecognizePageFields",
        IBMMainToCameraView = "IBMMainToCameraView",
        IBMMainToManualDeskew = "IBMMainToManualDeskew"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let imageEngineController = segue.destinationViewController as? IBMEditPageImageViewController where segue.identifier == IBMMainTableSegue.IBMMainToImageEngineSegue.rawValue {
            imageEngineController.originalImage = UIImage(named: "driver_demo")
            return
        }
        
        if let navController = segue.destinationViewController as? UINavigationController where segue.identifier == IBMMainTableSegue.IBMMainToImageEditorSegue.rawValue {
            let editor = createImageEditor()
            navController.showViewController(editor, sender: self)
        }
    
        if let loginViewController = segue.destinationViewController as? IBMLoginController where segue.identifier == IBMMainTableSegue.IBMMainToCheckProcessing.rawValue{
            loginViewController.demo = IBMDemo.CheckProcessing
        }
        
        if let loginViewController = segue.destinationViewController as? IBMLoginController where segue.identifier == IBMMainTableSegue.IBMMainToRecognizePageFields.rawValue{
            loginViewController.demo = IBMDemo.RecognizePageFields
        }
        
        if let cameraViewController = segue.destinationViewController as? IBMCameraViewController where segue.identifier == IBMMainTableSegue.IBMMainToCameraView.rawValue{
            cameraViewController.demo = IBMDemo.CameraView
        }
        
        if let cameraViewController = segue.destinationViewController as? IBMCameraViewController where segue.identifier == IBMMainTableSegue.IBMMainToManualDeskew.rawValue{
            cameraViewController.demo = IBMDemo.ManualDeskew
        }
        
    }
    
    func createImageEditor() -> ICPImageEditingController {
        let image = UIImage(named: "driver_demo")
        let imageEngine = ICPCoreImageImageEngine()
        
        let imageEditingController = ICPImageEditingController(originaImage: image!, modifiedImage: image!, imageEngine: imageEngine, validator: nil) { [weak self] (controller, image, changed) -> Void in
            
            guard let sself = self else {
                return
            }
            
            sself.dismissViewControllerAnimated(true, completion: nil)
        }
        
        imageEditingController.tintColor = UIColor.purpleColor()
        
        let rotateLeft = ICPImageEditingAction(actionType: .RotateLeft)
        imageEditingController.addImageEditingAction(rotateLeft)
        
        let rotate = ICPImageEditingAction(actionType: .RotateRight)
        imageEditingController.addImageEditingAction(rotate)
        
        let deskew = ICPImageEditingAction(actionType: .Deskew)
        imageEditingController.addImageEditingAction(deskew)
        
        if let customFilterImage = UIImage(named: "filters") {
            let filters = ICPImageEditingAction(image:customFilterImage, actionType: .Filters)
            imageEditingController.addImageEditingAction(filters)
        }
        
        if let blackAndWhiteImage = UIImage(named: "black_and_white") {
            let blackAndWhite = ICPImageEditingAction(image: blackAndWhiteImage) {
                return IBMUIImageEffects.CIBlackAndWhite($0) ?? $0
            }
            imageEditingController.addImageEditingAction(blackAndWhite)
        }
        
        
        let autoDeskew = ICPImageEditingAction(actionType: .AutoDeskew)
        imageEditingController.runImageEditingActionOnPresentation(autoDeskew)
        
        return imageEditingController
    }
    
}
