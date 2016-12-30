//
//  IBMEditPageImageViewController.swift
//  IBMCaptureSDK-Sample-Swift
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit
import BoxContentSDK
import IBMCaptureUISDK
import IBMCaptureSDK

class IBMEditPageImageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UploadVCProtocol{

    let IBMEditPageCellIdentifier = "IBMEditPageCellIdentifier"
    let imageEditor = ICPCoreImageImageEngine()
    let serivce = BoxService.init()
    let folderID = "0"
    
    enum IBMEditTool:Int {
        case Deskew = 0, Crop, BW, Grayscale, Rotate, Edge, Upload, Count
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
        case .Upload: return "Upload"
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
        case .Upload:
            //1)Apply Filter Code
            if self.applyFilterCode(self.getImageFile()!){
                self.addPopUp()
            }else{
                self.presentsFailure("Failed To Apply Filter")
            }
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
    
    //Pass in self.handleUploadResponse when calling this
    func uploadImage(data : NSData, fileName : String, completion: ((BOXFile!, NSError!) -> Void)!){
        self.serivce.upload(data, folderID : self.folderID, fileName: fileName){
            (file, error) in
            completion(file, error)
        }
    }
    
    func handleUploadResponse(file : BOXFile?, error: NSError?){
        if file != nil{
            self.presentsSuccess("")
        }else{
            self.presentsFailure(getErrorMessage(error!))
        }
    }
    
    func getErrorMessage(error : NSError?) -> String?{
        if error == nil {
            return nil
        }else {
            let key = "com.box.contentsdk.jsonerrorresponse"
            var errorResponse = error!.userInfo[key] as! NSDictionary
            let errorMessageKey = "message"
            return errorResponse[errorMessageKey] as! String
        }

    }
    
    func presentsSuccess(msg : String?){
        var message = "File has been uploaded"
        if msg != nil{
            message = msg!
        }
        let alertController = UIAlertController(title: "Upload Success", message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func presentsFailure(msg : String?){
        var message = "File failed to be uploaded"
        if msg != nil{
            message = msg!
        }
        let alertController = UIAlertController(title: "Upload Failed", message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func getImageData() -> NSData{
        let util = ImageUtil.init()
        return util.createBase64(self.getImageFile()!)
    }
    
    func getImageFile() -> UIImage?{
        let image = pageImage.image ?? originalImage
        return image
    }
    
    func uploadAction(fileNamePrefix : String) {
        
        //Upload It
        let fileName = fileNamePrefix + " "  + self.getDateString()
        self.uploadImage(self.getImageData(), fileName: fileName){
            (file, error) in
            self.handleUploadResponse(file, error: error)
        }

    }
    
    func applyFilterCode(image : UIImage) -> Bool{
        
        self.blackAndWhite(image)
        return true
    }
    
    func getFileName() -> String{
        return "Le File Name" + String(arc4random_uniform(100))
    }
    
    func addPopUp() -> Bool{
        //1. Create the alert controller.
        var alert = UIAlertController(title: "Alert", message: "Please enter a name", preferredStyle: .Alert)
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = "iOS Image"
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { [weak alert] (action) -> Void in
            let textField = alert!.textFields![0] as UITextField
            self.uploadAction(textField.text!)
            }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
        return true
    }
    
    func getDateString() -> String{
        
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd/HH/mm"
        //"dd.MM.yy"
        return formatter.stringFromDate(date)
        
    }
    
}
