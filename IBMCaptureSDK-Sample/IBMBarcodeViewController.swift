//
//  IBMBarcodeViewController.swift
//  IBMCaptureSDK-Sample-Swift
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit
import IBMCaptureSDK

extension ICPBarcodeType:CustomStringConvertible {
    public var description:String {
        switch self {
        case ICPBarcodeType.None: return "None"
        case ICPBarcodeType.Interleaved2of5: return "Interleaved 2 of 5"
        case ICPBarcodeType.Code39: return "Code 39"
        case ICPBarcodeType.Code39Extended: return "Code 39 Extended"
        case ICPBarcodeType.Code93: return "Code 93"
        case ICPBarcodeType.Code93Extended: return "Code 93 Extended"
        case ICPBarcodeType.Code128: return "Code 128"
        case ICPBarcodeType.EAN8: return "EAN8"
        case ICPBarcodeType.EAN13: return "EAN13"
        case ICPBarcodeType.UPCA: return "UPCA"
        case ICPBarcodeType.UPCE: return "UPCE"
        case ICPBarcodeType.PDF417: return "PDF 417"
        case ICPBarcodeType.DataMatrix: return "Data Matrix"
        case ICPBarcodeType.QRCode: return "QRCode"
        case ICPBarcodeType.Aztec: return "Aztec"
        default: return ""
        }
    }
}

class IBMBarcodeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let IBMBarcodeCellIdentifier = "IBMBarcodeCellIdentifier"
    
    @IBOutlet weak var barcodeImageView: UIImageView!
    @IBOutlet weak var barcodeTableView:UITableView!
    
    var barcodeImage:UIImage!
    var barcodeType:ICPBarcodeType = .None
    var barcodes:[ICPBarcode] = []
    
    let barcodeEngine = ICPZXingBarcodeEngine()
    let imageEditor = ICPCoreImageImageEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barcodeImageView.image = barcodeImage
    }
    
    //MARK: Table View configuration
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Barcodes"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barcodes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(IBMBarcodeCellIdentifier, forIndexPath: indexPath)
        let barcode = barcodes[indexPath.row]
        cell.textLabel?.text = barcode.code
        cell.detailTextLabel?.text = barcode.type.description
        return cell
    }
    
    //MARK: - Actions
    @IBAction func scanImage(sender: AnyObject) {
        
        guard let image = barcodeImageView.image else {
            return
        }
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let bounds = CGRect(origin: CGPointZero, size: image.size)
        barcodeEngine.recognizeBarcodeInImage(image, withBounds: bounds, withBarcodeHints: barcodeType) { [weak self] (barcodeList) -> Void in
            hud.hide(true)
            guard let barcodeList = barcodeList else {
                return
            }
            self?.barcodes = barcodeList
            self?.barcodeTableView.reloadData()
        }
    }
}
