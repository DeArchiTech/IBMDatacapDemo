//
//  ViewController.swift
//  IBMCaptureSDK-Sample-Swift
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit



class IBMLoginController: UITableViewController,  UITextFieldDelegate {

    enum IBMLoginControllerSection : Int {
        case Address = 0, User, Password, StationId
    }
    
    let IBMLoginToConfigSegueIdentifier = "IBMLoginToConfigSegueIdentifier"
    let IBMTextFieldCellID = "IBMTextFieldCell"
    
    var demo : IBMDemo?
    var baseURL = "http://ecm1.fws.io:8070/ServicewTM.svc"
    var username = "admin"
    var password = "admin"
    var stationId = "1"

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let controller = segue.destinationViewController as? IBMServiceConfigurationController where segue.identifier == IBMLoginToConfigSegueIdentifier{
            
            // 2. In order to access a remote service we ask the user to enter a URL and credentials.
            //    Credentials are managed by the NSURLCredential class.
            //    Please see IBMServiceConfigurationController.m next.
            
            controller.baseURL =     NSURL(string: self.baseURL)
            controller.credential =  NSURLCredential(user: self.username, password: self.password, persistence: .None)
            controller.stationId = self.stationId
            controller.demo = self.demo
        }
    }
    
    //MARK: UITableViewDatasource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let section = IBMLoginControllerSection(rawValue: section)!
        switch section{
        case .Address: return "URL Address"
        case .User: return "Username"
        case .Password: return "Password"
        case .StationId: return "Station Id"
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(IBMTextFieldCellID, forIndexPath: indexPath) as! IBMTextFieldCell
        cell.textField.tag = indexPath.section
        cell.textField.secureTextEntry = false
        cell.textField.keyboardType = .Default
        
        let section = IBMLoginControllerSection(rawValue: indexPath.section)!
        
        switch section{
        case .Address:
            cell.textField.text = self.baseURL
            cell.textField.keyboardType = .URL;
        case .User:
            cell.textField.text = self.username;
        case .Password:
            cell.textField.text = self.password
            cell.textField.secureTextEntry = true
        case .StationId:
            cell.textField.text = self.stationId
        }
        
        return cell
    
    }
    
    //MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldValue = textField.text else {
            return true
        }
        
        let newString = (textFieldValue as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        let section = IBMLoginControllerSection(rawValue: textField.tag)!
        
        switch section{
        case .Address: self.baseURL = newString
        case .User: self.username = newString
        case .Password: self.password = newString
        case .StationId: self.stationId =  newString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        }
        
        return true
    }

}

