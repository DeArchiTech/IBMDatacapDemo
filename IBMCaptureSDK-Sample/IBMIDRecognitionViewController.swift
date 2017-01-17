//
//  IBMIDRecognitionViewController.swift
//  IBMCaptureSDK-Sample
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit
import IBMCaptureSDK
import BoxContentSDK

class IBMIDRecognitionViewController: UIViewController, PODPresenter{

    var data:ICPMRZData?
    var podData:PodData?
    var service : BoxService?
    let folderID = "0"
    
    //1 - For the id processing, we gonna use and tesseract OCR engine with a trained data specific for the passport font type
//    lazy var ocrEngine = ICPTesseractOcrEngine(tessDataPrefixes: ["mrz"], andTessdataAbsolutePath: NSBundle.mainBundle().bundlePath)
    lazy var ocrEngine = ICPTesseractOcrEngine(tessDataPrefixes: ["eng"], andTessdataAbsolutePath: NSBundle.mainBundle().bundlePath)
    lazy var idProcessor:ICPIDProcessor = { [unowned self] in
       return ICPIDProcessor(OCREngine: self.ocrEngine)
    }()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: refactor
//        imageView.image = UIImage(named: "us_passport")
        imageView.image = UIImage(named: "pod")
        let action = UIBarButtonItem(title: "Recognize", style: .Plain, target: self, action: #selector(IBMIDRecognitionViewController.recognizeId(_:)))
        self.navigationItem.rightBarButtonItem = action
    }
    
    func recognizeId(sender:UIBarButtonItem) {
        guard let image = imageView.image else {
            data = nil
            tableView?.reloadData()
            return
        }

        let regconizePOD = true
        if regconizePOD {
            self.recognizePOD()
        }else {
            let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            idProcessor.processPassportImage(image) { [weak self] (mrzString, mrzData) in
                hud.hide(true)
                self?.data = mrzData
                self?.tableView?.reloadData()
            }
        }
    }
    
    func recognizePOD(){
        
        let aimage : UIImage? = self.imageView.image
        let width = aimage?.size.width
        let height = aimage?.size.height
        let rect : CGRect? = CGRect.init(x: 0, y: 0, width: width!, height: height!)
        let whiteList : String? = ""
        let highLightChars : Bool? = true
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        
        ocrEngine.recognizeTextInImage(aimage!, withRect: rect!, whitelist: whiteList!, highlightChars: highLightChars!){
            a,b,c in
            hud.hide(true)
            self.podData = self.createPODData(a,input: b,dict: c)
            self.tableView?.reloadData()
            self.pushAlertController()
        }
        
    }
    
    func createPODData(image : UIImage, input : String, dict : [String : [AnyObject]]) -> PodData {
        let helper = PodDataHelper.init(podString: input)
        return PodData.init(
            customerSalesOrder: ICPMRZField.init(value: helper.getCustomerSalesOrder(), confidence: 1, checked: true),
            customerId: ICPMRZField.init(value: helper.getCustomerId(), confidence: 1, checked: true),
            owner: ICPMRZField.init(value: "", confidence: 1, checked: true),
            customerName: ICPMRZField.init(value: "", confidence: 1, checked: true),
            deliveryAddress: ICPMRZField.init(value: "", confidence: 1, checked: true),
            ppmShipment: ICPMRZField.init(value: "", confidence: 1, checked: true),
            carrier: ICPMRZField.init(value: "", confidence: 1, checked: true),
            shipmentDate: ICPMRZField.init(value: "", confidence: 1, checked: true))
    }
    
    func pushAlertController() {
        
        var refreshAlert = UIAlertController(title: "Box Upload", message: "Would you like to upload to BOX?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            self.uploadToBox()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
    }
    
    func uploadToBox() {
        self.authenticate(){
            (user,error) in
            self.handleAuthenticateResponse(user, error: error)
        }
    }
    
    func authenticate(completion: ((BOXUser!, NSError!) -> Void)!){
        self.service = BoxService.init()
        self.service?.authenticate(){
            (user, error) in
            completion(user,error)
        }
    }
    
    func handleAuthenticateResponse(user : BOXUser?, error : NSError?) -> Bool{
        if error == nil{
//            self.presentsSuccess()
            self.addPopUp()
        }else{
            self.presentsFailure()
        }
        return true
    }
    
    func presentsSuccess(){
        let message = "User has been authenticated"
        let alertController = UIAlertController(title: "Authentication Success", message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func presentsFailure(){
        let message = "User has not been authenticated"
        let alertController = UIAlertController(title: "Authentication Failed", message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
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
    
    func uploadAction(fileNamePrefix : String) {
        
        //Upload It
        let fileName = fileNamePrefix + " "  + self.getDateString()
        self.uploadImage(self.getImageData(), fileName: fileName){
            (file, error) in
            self.handleUploadResponse(file, error: error)
        }
        
    }
    
    func getImageData() -> NSData{
        let util = ImageUtil.init()
        return util.createBase64(self.getImageFile()!)
    }
    
    func getImageFile() -> UIImage?{
        return imageView.image
    }
    
    func handleUploadResponse(file : BOXFile?, error: NSError?){
        if file != nil{
            self.presentsUploadSuccess("")
        }else{
            self.presentsUploadFailure(getErrorMessage(error!))
        }
    }
    
    func getErrorMessage(error : NSError?) -> String?{
        if error == nil {
            return nil
        }else {
            return "An Error Has Occured"
            //TODO REFACTOR!!!
            //            let key = "com.box.contentsdk.jsonerrorresponse"
            //            var errorResponse = error!.userInfo.first as! NSDictionary
            //            let errorMessageKey = "message"
            //            return errorResponse[errorMessageKey] as! String
        }
    }
    
    func presentsUploadSuccess(msg : String?){
        var message = "File has been uploaded"
        if msg != nil{
            message = msg!
        }
        let alertController = UIAlertController(title: "Upload Success", message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func presentsUploadFailure(msg : String?){
        var message = "File failed to be uploaded"
        if msg != nil{
            message = msg!
        }
        let alertController = UIAlertController(title: "Upload Failed", message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //Pass in self.handleUploadResponse when calling this
    func uploadImage(data : NSData, fileName : String, completion: ((BOXFile!, NSError!) -> Void)!){
        self.service!.upload(data, folderID : self.folderID, fileName: fileName){
            (file, error) in
            completion(file, error)
        }
    }
    
    func getDateString() -> String{
        
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm"
        //"dd.MM.yy"
        return formatter.stringFromDate(date)
        
    }
    
}

extension IBMIDRecognitionViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}

extension IBMIDRecognitionViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.titleForSection(section)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.numberOfSections()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRowsInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.tableView(tableView, cellForRowAtIndexPath: indexPath, withData: self.podData)
    }
}
