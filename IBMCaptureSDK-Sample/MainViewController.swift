//
//  MainViewController.swift
//  SDKSampleApp
//
//  Created by davix on 10/31/16.
//  Copyright © 2016 EMC Captiva. All rights reserved.
//
import UIKit
import Foundation

@objc class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var batchNum : Int = 0
    
    class func newInstance() -> MainViewController{
        return MainViewController()
    }
    
    var indicator : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator = UIActivityIndicatorView.init()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func presentFailureAlertController(){
        let message = "Failed to connect to server"
        let title = "Please try again with a more stable internet connection"
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func cameraBtnClicked(sender: AnyObject) {
        self.presentCamera()
    }
    
    
    @IBAction func galleryBtnClicked(sender: AnyObject) {
    }
    
    func presentCamera(){
        
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }else{
            self.pushImageEditViewController(UIImage(named: "pod")!)
        }
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imagePickerController(picker, pickedImage: image)
    }
    
    func imagePickerController(picker: UIImagePickerController, pickedImage: UIImage?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.pushImageEditViewController(pickedImage!)
    }
    
    func pushImageEditViewController(pickedImage: UIImage) -> Bool{
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("recognitionViewController") as! IBMIDRecognitionViewController
        // TODO: refactor
        //vc.imageView.image = pickedImage
        let navigationController = self.navigationController
        navigationController?.pushViewController(vc, animated: true)
        return true
        
    }

}
