//
//  IBMPassportTable.swift
//  IBMCaptureSDK-Sample
//
//  Created on 07/04/2016.
//  Copyright © 2016 Future Workshops. All rights reserved.
//

import Foundation
import IBMCaptureSDK

enum PODRowData:Int {
    case Facture = 0,
    CustomerName,
    CustomerSalesOrder,
    CustomerId,
    Owner,
    DeliveryAddress,
    PPMShipment,
    Carrier,
    ShipmentDate
}

protocol PODPresenter {
    func numberOfSections() -> Int
    func numberOfRowsInSection(section: Int) -> Int
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath, withData data: PodData?) -> UITableViewCell
}

extension PODPresenter {
    
    typealias FieldDisplay = (value:String, checked:Bool)
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func titleForSection(section:Int) -> String {
        return "POD Information"
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return 2
//        return PODRowData.Count.rawValue
        //return (section == 0 ? FirstRowData.Count.rawValue : SecondRowData.Count.rawValue)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath, withData data: PodData?) -> UITableViewCell {
        var identifier = String(self.dynamicType)
        identifier = "PodCell"
        guard let cell : PodCell = tableView.dequeueReusableCellWithIdentifier(identifier) as! PodCell else {
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: identifier)
            return configCell(cell, forRowAtIndexPath: indexPath, withData: data)
        }
        return configPodCell(cell, forRowAtIndexPath: indexPath, withData: data)
    }
    
    func configPodCell(cell: PodCell, forRowAtIndexPath indexPath:NSIndexPath, withData data: PodData?) -> PodCell {
        
        cell.itemLabel.text = titleForFieldAtIndex(indexPath)
        guard let data = data else {
            cell.detailTextLabel?.text = ""
            cell.accessoryType = .None
            return cell
        }
        
        let field:FieldDisplay?
        field = podRowFieldAtIndex(indexPath.row, onData: data)
        cell.itemValue?.text = field?.value
        //cell.accessoryType = (field?.checked == true ? .Checkmark : .None)
        return cell
    
    }
    
    func configCell(cell: UITableViewCell, forRowAtIndexPath indexPath:NSIndexPath, withData data: PodData?) -> UITableViewCell {
        
        cell.textLabel?.text = titleForFieldAtIndex(indexPath)
        
        guard let data = data else {
            cell.detailTextLabel?.text = ""
            cell.accessoryType = .None
            return cell
        }
        
        let field:FieldDisplay?
        field = podRowFieldAtIndex(indexPath.row, onData: data)
        cell.detailTextLabel?.text = field?.value
        //cell.accessoryType = (field?.checked == true ? .Checkmark : .None)
        return cell
    }
    
    func titleForFieldAtIndex(indexPath:NSIndexPath) -> String {
        
        guard let rowData = PODRowData(rawValue: indexPath.row) else {
            return ""
        }
        switch rowData {
        case .CustomerSalesOrder:
            return "Customer Sales Order"
        case .CustomerId:
            return "CustomerId"
        case .Owner:
            return "Owner"
        case .CustomerName:
            return "Customer Name"
        case .DeliveryAddress:
            return "Delivery Address"
        case .PPMShipment:
            return "PPM SHIPMENT"
        case .Carrier:
            return "Carrier"
        case .ShipmentDate:
            return "Shipment Date"
        case .Facture:
            return "Facture Number"
        }
        
    }
    
    func podRowFieldAtIndex(index:Int, onData data:PodData) -> FieldDisplay? {
        
        guard let rowData = PODRowData(rawValue: index) else {
            return ("", data.customerSalesOrder.checked)
        }
        switch rowData {
        case .CustomerSalesOrder:
            return (data.customerSalesOrder.value, data.customerSalesOrder.checked)
        case .CustomerId:
            return (data.customerId.value, data.customerSalesOrder.checked)
        case .Owner:
            return ("To Be Implemented", data.owner.checked)
        case .CustomerName:
            return (data.customerName.value, data.customerName.checked)
        case .DeliveryAddress:
            return ("To Be Implemented", data.deliveryAddress.checked)
        case .PPMShipment:
            return ("To Be Implemented", data.ppmShipment.checked)
        case .Carrier:
            return ("To Be Implemented", data.carrier.checked)
        case .ShipmentDate:
            return ("To Be Implemented", data.shipmentDate.checked)
        case .Facture:
            return (data.facture.value, data.customerSalesOrder.checked)
        }

    }
    
    func podTupleForDate(input:ICPMRZField) -> FieldDisplay? {
        guard let date = input.valueAsDate() else {
            return nil
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        return (dateFormatter.stringFromDate(date), input.checked)
    }
    
}
