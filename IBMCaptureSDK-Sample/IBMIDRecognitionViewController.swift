//
//  IBMIDRecognitionViewController.swift
//  IBMCaptureSDK-Sample
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit
import IBMCaptureSDK

class IBMIDRecognitionViewController: UIViewController, IBMPassportPresenter {

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
        
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        
        let aimage : UIImage? = self.imageView.image
        let width = aimage?.size.width
        let height = aimage?.size.height
        let rect : CGRect? = CGRect.init(x: 0, y: 0, width: width!, height: height!)
        let whiteList : String? = ""
        let highLightChars : Bool? = false
        
        ocrEngine.recognizeTextInImage(aimage!, withRect: rect!, whitelist: whiteList!, highlightChars: highLightChars!){
            a,b,c in
            print(a)
            print(b)
            print(c)
        }
        
//        idProcessor.processPassportImage(image) { [weak self] (mrzString, mrzData) in
//            hud.hide(true)
//            var txt = "ABCD"
//            print(mrzData)
//            print(mrzString)
//            self?.data = mrzData
//            self?.tableView?.reloadData()
//        }
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
        return self.tableView(tableView, cellForRowAtIndexPath: indexPath, withData: self.data)
    }
}
