//
//  IBMDocumentTableViewController.swift
//  IBMCaptureSDK-Sample-Swift
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit
import IBMCaptureUISDK
import IBMCaptureSDK

class IBMDocumentTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let IBMDocumentCellIdentifier = "IBMDocumentCellIdentifier"
    let IBMDocumentToPageSegue = "IBMDocumentToPageSegue"
    
    var cameraController:ICPCameraController!
    var document:ICPDocument!
    var objectFactory:ICPObjectFactory!

    lazy var imagePickerController:UIImagePickerController = { [unowned self] in
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        return imagePickerController
    }()
    
    // MARK: - Table view configuration

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Pages"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return document?.pages.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(IBMDocumentCellIdentifier, forIndexPath: indexPath)
        
        guard let page = document?.pages[indexPath.row] else {
            cell.textLabel?.text = ""
            return cell
        }
        
        cell.textLabel?.text = page.type?.typeId ?? ""
        
        return cell
    }
    
    //MARK: - Actions
    @IBAction func addPage(sender: AnyObject) {
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        guard let documentType = document.type as? ICPDocumentType,
            let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        let objects:[(String, ICPPageType)] = documentType.pageTypes.flatMap {
            let name = $0.typeId
            return (name, $0)
        }
        
        let selection = IBMSelectionTableViewController(itens: objects, selectionTitle: "Pages") { [weak self] (pageType) -> Void in
            self?.dismissViewControllerAnimated(true, completion: nil)
            guard let page = self?.objectFactory.pageWithDocument(self?.document, type: pageType) else {
                return
            }
            page.originalImage = image
            page.modifiedImage = image
            self?.tableView.reloadData()
        }
        let navigationController = UINavigationController(rootViewController: selection)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let pageController = segue.destinationViewController as? IBMPageViewController where segue.identifier == IBMDocumentToPageSegue {
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            
            let page = document.pages[indexPath.row]
            pageController.page = page
        }
    }
}