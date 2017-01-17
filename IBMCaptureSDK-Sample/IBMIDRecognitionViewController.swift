//
//  IBMIDRecognitionViewController.swift
//  IBMCaptureSDK-Sample
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit
import IBMCaptureSDK

class IBMIDRecognitionViewController: UIViewController, PODPresenter{

    var data:ICPMRZData?
    var podData:PodData?
    
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
