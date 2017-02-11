//
//  DatacapBackendService.swift
//  IBMCaptureSDK-Sample
//
//  Created by David Kwok Ho Chan on 2/8/17.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import BoxContentSDK
import IBMCaptureSDK
class DatacapBackendService{
    
    let serverUrl = "http://demo.revasolutions.com:8085"
    let userID = "admin"
    let password = "admin"
    let stationId = "1"
    
    var dataCapHelper : ICPDatacapHelper? = nil
    var sessionManager : ICPSessionManager? = nil
    var computationManager : ICPRemoteComputationManager? = nil
    
    var capture : ICPCapture? = nil
    var credential : NSURLCredential? = nil
    var service : ICPDatacapService? = nil
    //let dataCap : ICPDatacapRemoteComputationProvider
    
    init() {
    }
    
    func createPage(image : UIImage) -> ICPPage?{
        return nil
    }
    
    func authenticate(credentials : NSURLCredential) -> Bool{
        return false
    }
    
    func performOcrOnBackend() -> Bool {
        
        let serivce = self.createICPDatacapService()
        let helper = self.createDatacapHelper()
        return false
    }
    
    func createComputationManager() -> ICPRemoteComputationManager{
        
        let helper = self.createDatacapHelper()
        
        let loginProvider : ICPLoginProvider? = nil
        let remoteComputationProvider : ICPRemoteComputationProvider? = nil
        let manager = ICPRemoteComputationManager.init(loginProvider: loginProvider!, andRemoteComputationProvider: remoteComputationProvider!)
        return manager
    }
    
    func createSessionManager() -> ICPSessionManager{
        
        self.capture = self.createICPCapture()
        self.service = self.createICPDatacapService()
        self.credential = self.createCredential()
        if let sessionManager = self.capture?.datacapSessionManagerForService(self.service!, withCredential: self.credential!) {
            return sessionManager
        }
        let sessionManager = ICPSessionManager(objectFactory: (self.capture?.objectFactory)!, service: self.service!, andCredentials: self.credential!)
        return sessionManager
    
    }
    
    func createICPCapture() -> ICPCapture{
        return ICPCapture.instanceWithObjectFactoryType(.NonPersistent)!
    }
    
    func createCredential() -> NSURLCredential{
        return NSURLCredential(user: self.userID, password: self.password, persistence: .None)
    }
    
    func createICPDatacapService() -> ICPDatacapService{
        let capture = self.createICPCapture()
        let baseURL = self.createBaseUrl(self.serverUrl)
        let service = self.capture?.objectFactory?.datacapServiceWithBaseURL(baseURL)
        service!.station = self.capture!.objectFactory?.stationWithStationId(self.stationId, andIndex: 0, andDescription: "")
        service!.allowInvalidCertificates = true
        return service!
    }
    
    func createDatacapHelper() -> ICPDatacapHelper {
        
        let credential = self.createCredential()
        let service = self.createICPDatacapService()
        let capture = self.createICPCapture()
        let datacapHelper = ICPDatacapHelper(datacapService: service, objectFactory: capture.objectFactory!, credential: credential)
        return datacapHelper
    }
    
    func createFields() -> [ICPField] {
        return []
    }
    
    func createFactureField() -> ICPField? {
        //Might need to implement ICPField since its a protocol
        return nil
    }
    
    func createRect(x : Double, y: Double, width : Double, height: Double) -> ICPRect {
        let origin = ICPPoint.init(x: x, y: y)
        let size = ICPSize.init(width: width, height: height)
        return ICPRect.init(origin: origin, size: size)
    }
    
    func createBaseUrl(url : String) -> NSURL{
        return NSURL(string: url)!
    }
}
