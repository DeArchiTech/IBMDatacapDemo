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
    var metaDataDictionary : Dictionary<String,String>?
    var folderID = "0"
    let podFolderID = "16978324036"
    let imageEditor = ICPCoreImageImageEngine()
    var pickedImage : UIImage? = nil
    
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
        self.folderID = self.podFolderID
        self.service = BoxService.init()
        let action = UIBarButtonItem(title: "Recognize", style: .Plain, target: self, action: #selector(IBMIDRecognitionViewController.recognizeId(_:)))
        self.navigationItem.rightBarButtonItem = action
        self.metaDataDictionary = Dictionary<String,String>()
        self.setUpImageViewImage()
    }
    
    func setUpImageViewImage(){
        if pickedImage == nil{
            imageView.image = UIImage(named: "podSample20")
        }else{
            imageView.image = self.pickedImage!
        }
    }
    
    func recognizeId(sender:UIBarButtonItem) {
        guard let image = imageView.image else {
            data = nil
            tableView?.reloadData()
            return
        }

        let regconizePOD = true
        if regconizePOD {
            self.applyFilterCode(self.imageView.image!){
                self.recognizePOD()
            }
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
        //whitelist: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ()", highlightChars: false) 
        let highLightChars : Bool? = false
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "Performing OCR on the Image"
        
        ocrEngine.recognizeTextInImage(aimage!, withRect: rect!, whitelist: whiteList!, highlightChars: highLightChars!){
            a,b,c in
            hud.hide(true)
            //print(a)
            print(b)
            //print(c)
            self.podData = self.createPODData(a,input: b,dict: c)
            self.setUpMetaData(self.podData!, ocr: b)
            self.tableView?.reloadData()
            self.pushImageRegonitionIsNowCompleteAlert()
        }
        
    }
    
    func createPODData(image : UIImage, input : String, dict : [String : [AnyObject]]) -> PodData {
        let helper = PodDataHelper.init(podString: input)
        let data = PodData.init(
            customerSalesOrder: ICPMRZField.init(value: helper.getCustomerSalesOrder(), confidence: 1, checked: true),
            customerId: ICPMRZField.init(value: helper.getCustomerId(), confidence: 1, checked: true),
            owner: ICPMRZField.init(value: "", confidence: 1, checked: true),
            customerName: ICPMRZField.init(value: "", confidence: 1, checked: true),
            deliveryAddress: ICPMRZField.init(value: "", confidence: 1, checked: true),
            ppmShipment: ICPMRZField.init(value: "", confidence: 1, checked: true),
            carrier: ICPMRZField.init(value: "", confidence: 1, checked: true),
            shipmentDate: ICPMRZField.init(value: "", confidence: 1, checked: true),
            facture: ICPMRZField.init(value: "", confidence: 1, checked: true))
        data.setUpMockData()
        return data
    }
    
    func setUpMetaData(podData : PodData, ocr : String){
        
        self.metaDataDictionary!["checked"] = "true"
        self.metaDataDictionary!["accuracy"] = "90"
        self.metaDataDictionary!["customersalesorder"] = podData.customerSalesOrder.value
        self.metaDataDictionary!["customerid"] = podData.customerId.value
        self.metaDataDictionary!["customername"] = podData.customerName.value
        self.metaDataDictionary!["facture"] = podData.facture.value
        self.metaDataDictionary!["ocr"] = ocr
        
    }
    
    func pushImageRegonitionIsNowCompleteAlert() {
        
        var refreshAlert = UIAlertController(title: "Image Regonition Complete", message: "Do you want to manually enter the facture number?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            self.addFactureNameFieldPopUp()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: { (action: UIAlertAction!) in
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
    }
    
    func handleAuthenticateResponse(user : BOXUser?, error : NSError?) -> Bool{
        if error == nil{
            //self.presentsSuccess()
        }else{
            self.presentsFailure()
        }
        return true
    }
    
    func getFactureNumber(dictionary: Dictionary<String,String>) -> String{
        
        if let num = dictionary["facture"]{
            return num
        }
        return "facture Number"
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

    func addNameFieldPopUp() -> Bool{
        
        //1. Create the alert controller.
        var alert = UIAlertController(title: "Alert", message: "Please enter a name", preferredStyle: .Alert)
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = "iOS Image"
        })
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { [weak alert] (action) -> Void in
            //let textField = alert!.textFields![0] as UITextField
            //self.uploadAction(textField.text!)
            }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
        return true
        
    }
    
    func addFactureNameFieldPopUp() -> Bool{
        
        //1. Create the alert controller.
        var alert = UIAlertController(title: "Please Insert Facture Number", message: "Please enter a valid facture number", preferredStyle: .Alert)
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            //textField.text = "iOS Image"
        })
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { [weak alert] (action) -> Void in
            let textField = alert!.textFields![0] as UITextField
            let factureNumber : String = textField.text!
            self.updateFactureNumber(factureNumber)
            }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
        return true
        
    }
    
    func updateFactureNumber(factureNumber : String) {
        self.metaDataDictionary!["facture"] = factureNumber
        self.podData?.facture = ICPMRZField.init(value: factureNumber, confidence: 1, checked: true)
        self.tableView?.reloadData()
    }
    
    func authenticate(completion: ((BOXUser!, NSError!) -> Void)!){
        self.service?.authenticate(){
            (user, error) in
            completion(user,error)
        }
    }
    
    func uploadAction(fileNamePrefix : String) {
        
        //Upload It
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "Uploading image to box"
        let fileName = self.addSuffixToFileName(fileNamePrefix)
        self.authenticate(){
            (user,error) in
            self.handleAuthenticateResponse(user, error: error)
            self.uploadImage(self.getImageData(), fileName: fileName){
                (file, error) in
                hud.hide(true)
                self.handleUploadResponse(file, error: error)
            }
        }
        
    }
    
    func getFolderFromBox(folderName: String, completion: ((AnyObject) -> Void)!){
        
        self.service?.findFolderWithName(self.folderID, folderName: folderName){
            (folder) in
            if folder != nil{
                completion(folder)
            }else{
                self.service?.createFolder(folderName){
                    (folder, error) in
                    completion(folder)
                }
            }
        }
        
    }
    
    func addSuffixToFileName(prefix : String) -> String{
        return prefix + " " + self.getDateString() + ".jpg"
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
            let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            hud.labelText = "Adding metadata to the file instance"
            self.addMetaData((file?.modelID)!, dictionary: self.metaDataDictionary!){
                (data,error) in
                hud.hide(true)
                self.presentsUploadSuccess("")
            }
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
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: { (action: UIAlertAction!) in
            self.navigationController?.popViewControllerAnimated(true)
        }))
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
        let customerName = BoxServiceUtil().getFolderName(self.metaDataDictionary!)
        self.getFolderFromBox(customerName){
            (object) in
            if let folder = object as? BOXFolder {
                self.service!.upload(data, folderID : folder.modelID!, fileName: fileName){
                    (file, error) in
                    completion(file, error)
                }
            }else{
                self.presentsUploadFailure("An error has occured when trying to create the folder")
                completion(nil,nil)
            }
        }
    }
    
    func getDateString() -> String{
        return BoxServiceUtil().getDateString()
    }
    
    func addMetaData(fileID : String, dictionary : Dictionary<String, String>, completionBlock : BOXMetadataBlock){
        
        self.service?.createMetadataOnFile(fileID){
            (data, error) in
            self.service?.updateMetaData(fileID, dictionary: dictionary){
                (updatedData, error) in
                print(updatedData)
                completionBlock(updatedData,error)
            }
        }
    }
        
    func addMetaDataTemplate(file : BOXFile, completionBlock : BOXMetadataBlock){
        self.service?.createMetadataOnFile(self.getFileID(file), completionBlock: completionBlock)
    }
    
    func getFileID(file :BOXFile) -> String{
        return BoxServiceUtil().getFileID(file)
    }
    
    func applyFilterCode(image : UIImage, completion: () -> Void) -> Bool{
        
        self.deskew(image, completion: completion)
        return true
    
    }
    
    func blackAndWhite(image:UIImage, completion: () -> Void) {
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Applying black and white Filter"
        imageEditor.applyFilter(.BlackAndWhite, toImage: image) { [weak self] (blackWhiteImage) -> Void in
            hud.hide(true)
            guard let blackWhiteImage = blackWhiteImage else {
                return
            }
            self?.imageView.image = blackWhiteImage
            completion()
        }
    }
    
    func deskew(image:UIImage, completion: () -> Void){
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Applying deskew filter"
        imageEditor.detectEdgesAndDeskewImage(image, withValidator:  nil) { [weak self] (deskedImage) -> Void in
            hud.hide(true)
            guard let deskedImage = deskedImage else {
                return
            }
            self?.imageView.image = deskedImage
            completion()
        }
    }
    
    func detectEdges(image:UIImage, completion: () -> Void){
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Applying detect edge filter"
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
            completion()
        }
        
    }
    
    @IBAction func uploadBtnClicked(sender: AnyObject) {
        if let fileName = self.metaDataDictionary!["facture"]{
            self.uploadAction(fileName)
        }else{
            let message = "Please first apply OCR onto the image"
            let alertController = UIAlertController(title: "Upload Failure", message:
                message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    func alertController(title title:String, message:String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(alertAction)
        return alertController
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
