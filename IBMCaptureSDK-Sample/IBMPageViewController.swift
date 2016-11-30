//
//  IBMPageViewController.swift
//  IBMCaptureSDK-Sample-Swift
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit
import IBMCaptureSDK

class IBMPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let IBMPageCellIdentifier = "IBMPageCellIdentifier"
    
    @IBOutlet weak var pageImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var hud : MBProgressHUD?
    var page:ICPPage!
    var service : ICPDatacapService!
    var sessionManager:ICPSessionManager!
    var checkCountry : ICPCheckCountry!
    var credential : NSURLCredential!
    var demo : IBMDemo?
    
    lazy var remoteComputationManager : ICPRemoteComputationManager = { [unowned self] in
        let remoteComputationManager = self.sessionManager.datacapRemoteComputationManager()
        return remoteComputationManager
    }()
    
    //MARK: View configuration
    override func viewWillAppear(animated: Bool) {
        
        self.configureRightNavigationItem()
        
        pageImage.image = page.modifiedImage ?? page.originalImage
        super.viewWillAppear(animated)
    }
    
    //MARK: Table view configuration
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return page?.fields.count ?? 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Fields"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(IBMPageCellIdentifier, forIndexPath: indexPath)
        
        guard let field = page?.fields[indexPath.row], let type = field.type as? ICPFieldType else {
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
            return cell
        }
        
        cell.textLabel?.text = type.typeId
        cell.detailTextLabel?.text = field.value == nil ? "" : "\(field.value!)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard let field = page?.fields[indexPath.row], let type = field.type as? ICPFieldType else {
            return
        }
        let alertController = UIAlertController(title: nil, message: type.typeId, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler {
            $0.placeholder = ""
            $0.text = field.value == nil ? "" : "\(field.value!)"
        }
        
        let alertAction = UIAlertAction(title: "Done", style: .Default) {(action) -> Void in
            guard let textField = alertController.textFields?.first else {
                return
            }
            field.value = textField.text
            dispatch_async(dispatch_get_main_queue(), { [weak self] () -> Void in
                self?.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            })
        }
        alertController.addAction(alertAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: Actions
    
    func configureRightNavigationItem(){
        
        if(self.demo == .CheckProcessing){
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Process", style: UIBarButtonItemStyle.Done, target: self, action: #selector(IBMPageViewController.processCheck))
        }else if(self.demo == .RecognizePageFields){
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Recognize", style: UIBarButtonItemStyle.Done, target: self, action: #selector(IBMPageViewController.recognizePageFields))
        }
        
    }
    
    func processCheck (){
        
        self.startServerRequest()
        self.remoteComputationManager.processCheck(self.page, checkCountry: self.checkCountry, keepAlive: false) { [weak self] (success, fields, error) -> Void in
            self?.endServerRequest()
            
            if success  {
                self?.updatePageWithResultInTransactionClient(fields)
            }else{
                self?.showError(error)
                
            }
        }
    }
    
    func recognizePageFields (){
        
        self.startServerRequest()
        self.remoteComputationManager.recognizePageFields(self.page, recognitionEngine: .Default) { [weak self] (success, fields, error) -> Void in
            self?.endServerRequest()
            
            if success  {
                self?.updatePageWithResultInTransactionClient(fields)
            } else {
                self?.showError(error)
            }
        }
    }
    
    func startServerRequest(){
        self.hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        self.navigationItem.rightBarButtonItem?.enabled = false
    }
    
    func endServerRequest(){
        self.navigationItem.rightBarButtonItem?.enabled = true
        self.hud?.hide(true)
    }
    
    func updatePageWithResultInTransactionClient(fields:[ICPField]){
        
        self.remoteComputationManager.updatePage(self.page, withResults: fields, skipNonBlankFields: false) { [weak self] (success, page, error) -> Void in
            self?.tableView.reloadData()
        }
    }
    
    func showError(error:NSError?) {
        guard let error = error else {
            return
        }
        
        showAlert(title: "Error", message: error.localizedDescription)
    }
    
    func showAlert(title title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(alertAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
