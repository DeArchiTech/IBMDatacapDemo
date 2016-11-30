//
//  IBMBarcodeTableViewController.swift
//  IBMCaptureSDK-Sample-Swift
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit
import IBMCaptureSDK

class IBMBarcodeTableViewController: UITableViewController {

    let IBMBarcodeTableViewCellIdentifier = "IBMBarcodeTableViewCellIdentifier"
    let IBMBarcodeTableViewToBarcodeViewSegue = "IBMBarcodeTableViewToBarcodeViewSegue"
    
    enum IBMBarcodeType:Int, CustomStringConvertible {
        case Document = 0,
        Several,
        Interleaved,
        Code39,
        Code39Extended,
        Code93Extended,
        Code93,
        Code128,
        Ean8,
        Ean13,
        Upca,
        Upce,
        Pdf417,
        DataMatrix,
        QrCode,
        Aztec,
        Count
        
        var description:String {
            switch self {
            case .Document: return "Document"
            case .Several: return "Different Types"
            case .Interleaved: return "Interleaved 2 of 5"
            case .Code39: return "Code 39"
            case .Code39Extended: return "Code 39 Extended"
            case .Code93: return "Code 93"
            case .Code93Extended: return "Code 93 Extended"
            case .Code128: return "Code 128"
            case .Ean8: return "EAN8"
            case .Ean13: return "EAN13"
            case .Upca: return "UPCA"
            case .Upce: return "UPCE"
            case .Pdf417: return "PDF 417"
            case .DataMatrix: return "Data Matrix"
            case .QrCode: return "QRCode"
            case .Aztec: return "Aztec"
            case .Count: return ""
            }
        }
    }
    
    func icpType(barcodeType:IBMBarcodeType) -> ICPBarcodeType {
        switch barcodeType {
        case .Count, .Document, .Several: return .None
        case .Interleaved: return .Interleaved2of5
        case .Code39: return .Code39
        case .Code39Extended: return .Code39Extended
        case .Code93: return .Code93
        case .Code93Extended: return .Code93Extended
        case .Code128: return .Code128
        case .Ean8: return .EAN8
        case .Ean13: return .EAN13
        case .Upca: return .UPCA
        case .Upce: return .UPCE
        case .Pdf417: return .PDF417
        case .DataMatrix: return .DataMatrix
        case .QrCode: return .QRCode
        case .Aztec: return .Aztec
        }
    }
    
    func barcodeImage(barcodeType:IBMBarcodeType) -> UIImage? {
        
        let imageName:String
        
        switch barcodeType {
        case .Count, .Document: imageName = "carloan"
        case .Several: imageName = "some_barcodes.jpg"
        case .Interleaved: imageName = "barcode_itf.jpg"
        case .Code39, .Code39Extended: imageName = "barcode_code_39.jpg"
        case .Code93, .Code93Extended: imageName = "barcode_code_93.jpg"
        case .Code128: imageName = "barcode_code_128.jpg"
        case .Ean8: imageName = "barcode_ean_8.jpg"
        case .Ean13: imageName = "barcode_ean_13_sup.jpg"
        case .Upca: imageName = "barcode_upc_a.jpg"
        case .Upce: imageName = "barcode_upc_e.jpg"
        case .Pdf417: imageName = "barcode_ean_pdf_417.jpg"
        case .DataMatrix: imageName = "barcode_data_matrix.jpg"
        case .QrCode: imageName = "barcode_qr_code"
        case .Aztec: imageName = "barcode_aztec.jpg"
        }
        
        return UIImage(named: imageName)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IBMBarcodeType.Count.rawValue
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("IBMBarcodeTableViewCellIdentifier", forIndexPath: indexPath)
        
        guard let type = IBMBarcodeType(rawValue: indexPath.row) else {
            cell.textLabel?.text = ""
            return cell
        }
        
        cell.textLabel?.text = "\(type)"
        
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let barcodeController = segue.destinationViewController as? IBMBarcodeViewController where segue.identifier == IBMBarcodeTableViewToBarcodeViewSegue {
            guard let indexPath = tableView.indexPathForSelectedRow, let type = IBMBarcodeType(rawValue: indexPath.row) else {
                return
            }
            
            barcodeController.barcodeType = icpType(type)
            barcodeController.barcodeImage = barcodeImage(type)
            barcodeController.title = type.description
        }
    }
    
}
