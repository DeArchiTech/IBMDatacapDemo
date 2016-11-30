//
//  IBMMRZDecodingViewController.swift
//  IBMCaptureSDK-Sample
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit
import IBMCaptureSDK

class IBMMRZDecodingViewController: UIViewController, IBMPassportPresenter {

    let mrzDecoder = ICPMRZDecoder()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mrzText: UITextView!
    var data:ICPMRZData?
    var dateFormatter:NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let actionButton = UIBarButtonItem(title: "Perform", style: .Plain, target: self, action: #selector(IBMMRZDecodingViewController.performMRZ(_:)))
        self.navigationItem.rightBarButtonItem = actionButton
    }
    
    func performMRZ(sender:UIBarButtonItem) {
        
        defer {
            tableView?.reloadData()
        }
        
        mrzText?.resignFirstResponder()
        
        guard let text = mrzText?.text where text.characters.count > 0 else {
            data = nil
            return
        }
        
        //1: The decodeString(_:ofType:withMaxConfidence:) function will parse the provided string into an ICPMRZData object
        data = mrzDecoder.decodeString(text, ofType: .Complete, withMaxConfidence: NSNumber(integer: 1))
    }
}

extension IBMMRZDecodingViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}

extension IBMMRZDecodingViewController : UITableViewDataSource {
    
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
