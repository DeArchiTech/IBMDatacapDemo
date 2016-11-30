//
//  IBMPassportTable.swift
//  IBMCaptureSDK-Sample
//
//  Created on 07/04/2016.
//  Copyright © 2016 Future Workshops. All rights reserved.
//

import Foundation
import IBMCaptureSDK

enum FirstRowData:Int {
    case Type = 0,
    SubType,
    CountryCode,
    GivenName,
    Surname,
    Count
}

enum SecondRowData:Int {
    case Number = 0,
    Nationality,
    Birthdate,
    Sex,
    Expiration,
    PersonalId,
    Count
}

protocol IBMPassportPresenter {
    func numberOfSections() -> Int
    func numberOfRowsInSection(section: Int) -> Int
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath, withData data: ICPMRZData?) -> UITableViewCell
}

extension IBMPassportPresenter {
    
    typealias FieldDisplay = (value:String, checked:Bool)
    
    func numberOfSections() -> Int {
        return 2
    }
    
    func titleForSection(section:Int) -> String {
        return (section == 0 ? "Top Line" : "Bottom Line")
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return (section == 0 ? FirstRowData.Count.rawValue : SecondRowData.Count.rawValue)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath, withData data: ICPMRZData?) -> UITableViewCell {
        let identifier = String(self.dynamicType)
        guard let cell = tableView.dequeueReusableCellWithIdentifier(identifier) else {
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: identifier)
            return configCell(cell, forRowAtIndexPath: indexPath, withData: data)
        }
        
        return configCell(cell, forRowAtIndexPath: indexPath, withData: data)
    }
    
    func configCell(cell: UITableViewCell, forRowAtIndexPath indexPath:NSIndexPath, withData data: ICPMRZData?) -> UITableViewCell {
        
        cell.textLabel?.text = titleForFieldAtIndex(indexPath)
        
        guard let data = data else {
            cell.detailTextLabel?.text = ""
            cell.accessoryType = .None
            return cell
        }
        
        let field:FieldDisplay?
        if indexPath.section == 0 {
            field = firstRowFieldAtIndex(indexPath.row, onData: data)
        } else {
            field = secondRowFieldAtIndex(indexPath.row, onData: data)
        }
        
        cell.detailTextLabel?.text = field?.value
        cell.accessoryType = (field?.checked == true ? .Checkmark : .None)
        
        return cell
    }
    
    func titleForFieldAtIndex(indexPath:NSIndexPath) -> String {
        
        if let rowData = FirstRowData(rawValue: indexPath.row) where indexPath.section == 0 {
            switch rowData {
            case .Type:
                return "Type"
            case .SubType:
                return "SubType"
            case .CountryCode:
                return "Country code"
            case .GivenName:
                return "Given Name"
            case .Surname:
                return "Surname"
            case .Count:
                return ""
            }
        }
        
        if let rowData = SecondRowData(rawValue: indexPath.row) where indexPath.section == 1 {
            switch rowData {
            case .Number:
                return "Passport Number"
            case .Nationality:
                return "Nationality"
            case .Birthdate:
                return "Birthdate"
            case .Sex:
                return "Sex"
            case .Expiration:
                return "Expiration"
            case .PersonalId:
                return "Personal ID"
            case .Count:
                return ""
            }
        }
        
        return ""
    }
    
    func firstRowFieldAtIndex(index:Int, onData data:ICPMRZData) -> FieldDisplay? {
        guard let rowData = FirstRowData(rawValue: index) else {
            return nil
        }
        
        switch rowData {
        case .Type:
            return (data.type.value, data.type.checked)
        case .SubType:
            return (data.subType.value, data.type.checked)
        case .CountryCode:
            return (data.countryCode.value, data.type.checked)
        case .GivenName:
            return (data.givenName.value, data.type.checked)
        case .Surname:
            return (data.surname.value, data.type.checked)
        case .Count:
            return nil
        }
    }
    
    func secondRowFieldAtIndex(index:Int, onData data:ICPMRZData) -> FieldDisplay? {
        guard let rowData = SecondRowData(rawValue: index) else {
            return nil
        }
        
        switch rowData {
        case .Number:
            return (data.passportNumber.value, data.passportNumber.checked)
        case .Nationality:
            return (data.nationality.value, data.nationality.checked)
        case .Birthdate:
            return tupleForDate(data.birthdate)
        case .Sex:
            return (data.sex.value, data.sex.checked)
        case .Expiration:
            return tupleForDate(data.passportExpirationDate)
        case .PersonalId:
            return (data.personalId.value, data.personalId.checked)
        case .Count:
            return nil
        }
    }
    
    func tupleForDate(input:ICPMRZField) -> FieldDisplay? {
        guard let date = input.valueAsDate() else {
            return nil
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        return (dateFormatter.stringFromDate(date), input.checked)
    }
}
