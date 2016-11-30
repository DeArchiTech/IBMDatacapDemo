//
//  IBMEditPageImageViewController.swift
//  IBMCaptureSDK-Sample-Swift
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit
import IBMCaptureUISDK
import IBMCaptureSDK

class IBMEditPageImageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let IBMEditPageCellIdentifier = "IBMEditPageCellIdentifier"
    let imageEditor = ICPCoreImageImageEngine()
    
    enum IBMEditTool:Int {
        case Deskew = 0, Crop, BW, Grayscale, Rotate, Edge, Count
    }
    
    @IBOutlet weak var pageImage:UIImageView!
    @IBOutlet weak var tableView:UITableView!
    
    var originalImage:UIImage!
    var changeNotifier:((UIImage)->Void)?
    
    var modifiedImage:UIImage! {
        get {
            return pageImage.image ?? originalImage
        }
        set {
            pageImage.image = newValue
            changeNotifier?(newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageImage.image = originalImage
    }
    
    //MARK: Table view configuration
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectZero)
        return view
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Edit Tools"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IBMEditTool.Count.rawValue
    }
    
    func titleForItem(item:Int) -> String {
        guard let tool = IBMEditTool(rawValue: item) else {
            return ""
        }
        switch tool {
        case .Deskew: return "Deskew"
        case .Crop: return "Crop"
        case .BW: return "B&W"
        case .Grayscale: return "Grayscale"
        case .Rotate: return "Rotate 90"
        case .Edge: return "Detect Edges"
        case .Count: return ""
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(IBMEditPageCellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = titleForItem(indexPath.row)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard let tool = IBMEditTool(rawValue: indexPath.row), let image = (pageImage.image ?? originalImage) else {
            return
        }
        
        switch tool {
        case .Deskew:
            deskew(image)
        case .Crop:
            crop(image)
        case .BW:
            blackAndWhite(image)
        case .Grayscale:
            grayscale(image)
        case .Rotate:
            rotateImage(image)
        case .Edge:
            detectEdges(image)
        case .Count:
            return
        }
    }
    
    //MARK: Actions
    @IBAction func resetImage(sender: AnyObject) {
        modifiedImage = originalImage
    }
    
    
    //MARK: Tools
    func deskew(image:UIImage) {
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        imageEditor.detectEdgesAndDeskewImage(image, withValidator:  nil) { [weak self] (deskedImage) -> Void in
            hud.hide(true)
            guard let deskedImage = deskedImage else {
                return
            }
            self?.modifiedImage = deskedImage
        }
    }
    
    func crop(image:UIImage) {
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let rect = CGRect(x: image.size.width * 0.5,
            y: image.size.height * 0.5,
            width: image.size.width * 0.5,
            height: image.size.height * 0.5);
        imageEditor.cropRect(rect, inImage: image) { [weak self] (cropedImage) -> Void in
            hud.hide(true)
            guard let cropedImage = cropedImage else {
                return
            }
            self?.modifiedImage = cropedImage
        }
    }
    
    func blackAndWhite(image:UIImage) {
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        imageEditor.applyFilter(.BlackAndWhite, toImage: image) { [weak self] (blackWhiteImage) -> Void in
            hud.hide(true)
            guard let blackWhiteImage = blackWhiteImage else {
                return
            }
            self?.modifiedImage = blackWhiteImage
        }
    }
    
    func grayscale(image:UIImage) {
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        imageEditor.applyFilter(.Grayscale, toImage: image) { [weak self] (grayscaleImage) -> Void in
            hud.hide(true)
            guard let grayscaleImage = grayscaleImage else {
                return
            }
            self?.modifiedImage = grayscaleImage
        }
    }
    
    func rotateImage(image:UIImage) {
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        imageEditor.rotateToLeftImage(image) { [weak self] (rotatedImage) -> Void in
            hud.hide(true)
            guard let rotatedImage = rotatedImage else {
                return
            }
            self?.modifiedImage = rotatedImage
        }
    }
    
    func detectEdges(image:UIImage) {
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        imageEditor.detectEdgePointsInImage(image, withValidator:nil) { [weak self] (points) -> Void in
            hud.hide(true)
            
            let alertMessage:String
            
            defer {
                if let alert = self?.alertController(title: "Edges", message: alertMessage) {
                    self?.presentViewController(alert, animated: true, completion: nil)
                }
            }
            
            guard let nsPoints = points where nsPoints.count > 0 else {
                alertMessage = "Couldn't detect the edges"
                return
            }
            
            var messageString = ""
            
            for (index, nsPoint) in nsPoints.enumerate() {
                let cgPoint = nsPoint.CGPointValue()
                let x = String(format: "%.2f", cgPoint.x)
                let y = String(format: "%.2f", cgPoint.y)
                
                messageString = "\(messageString)\n Edge \(index): \(x) x \(y)"
            }
            
            alertMessage = messageString
        }
        
    }
    
    func alertController(title title:String, message:String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(alertAction)
        return alertController
    }
}