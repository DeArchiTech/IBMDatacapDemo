//
//  IBMCameraViewController.swift
//  IBMCaptureSDK-Sample-Swift
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//
import UIKit
import IBMCaptureSDK
import IBMCaptureUISDK

class IBMCameraViewController: UIViewController, ICPCameraViewDelegate {

    let IBMCameraControllerToPage = "IBMCameraControllerToPage"
    let IBMCameraControllerToManualDeskewImageView = "IBMCameraControllerToManualDeskewImageView"
    
    @IBOutlet weak var cameraView : ICPCameraView!
    @IBOutlet weak var label : UILabel!
    
    var objectFactory:ICPObjectFactory!
    var demo : IBMDemo?
    var sessionManager:ICPSessionManager!
    
    deinit{
        self._removeNotificationObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cameraView.delegate = self
        
        //Optional setup
        self.cameraView.minimumScreenPercentage = 0.5
        self.cameraView.maximumAspectRatio = 6
        self.cameraView.minimumAspectRatio = 0.2
        self.cameraView.accelerationThreshold = 0.1
        self.cameraView.detectDocumentsWithTextOnly = true
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.cameraView.restartPreview()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(IBMCameraViewController._stopPreview), name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(IBMCameraViewController._restartPreview), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.cameraView.stopPreview()
        
        self._removeNotificationObservers()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if let pageViewController = segue.destinationViewController as? IBMPageViewController where segue.identifier == IBMCameraControllerToPage{
            
            let capture = ICPCapture.instanceWithObjectFactoryType(.NonPersistent)
            let objectFactory = capture?.objectFactory
            let page = objectFactory?.pageWithDocument(nil, type: nil)
            page?.modifiedImage = sender as? UIImage
            pageViewController.sessionManager = sessionManager
            pageViewController.page = page
            pageViewController.demo = self.demo
            
        }else if let imageViewController = segue.destinationViewController as? IBMImageViewController where segue.identifier == IBMCameraControllerToManualDeskewImageView{
            imageViewController.image = sender as? UIImage
        }
    }
    
    func _restartPreview(){
        self.cameraView.restartPreview()
    }
    
    func _stopPreview(){
        self.cameraView.stopPreview()
    }
    
    func _removeNotificationObservers(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    // MARK: ICPCameraViewDelegate
    
    func cameraView(cameraView: ICPCameraView, didTakeOriginalPhoto originalPhoto: UIImage?, modifiedPhoto: UIImage?) {
        
        if(self.demo == .CameraView){
            self.performSegueWithIdentifier(IBMCameraControllerToPage, sender: modifiedPhoto)
        }else if(self.demo == .ManualDeskew){
            self.performSegueWithIdentifier(IBMCameraControllerToManualDeskewImageView, sender: originalPhoto)
        }
        
    }
    
    func cameraViewDidDetectDocument(cameraView: ICPCameraView){
        self.cameraView.takePhoto()
    }
    
    func cameraView(cameraView: ICPCameraView, didChangeState cameraState: ICPCameraViewState) {
        if (cameraState == .LookingForDocument) {
            self.label.text = "Looking for document ..."
        }else if(cameraState == .CameraMoving){
            self.label.text = "Hold camera in place"
        }else if(cameraState == .InvalidRatio){
            self.label.text = "Document has invalid aspect ratio"
        }else if(cameraState == .DocumentTooSmall){
            self.label.text = "Bring camera closer"
        }else if(cameraState == .DocumentDetected){
            self.label.text = "Document Detected"
        }else if(cameraState == .CannotDetectTextInDocument){
            self.label.text = "Cannot detect text"
        }else{
            self.label.text = ""
        }
    }

}
