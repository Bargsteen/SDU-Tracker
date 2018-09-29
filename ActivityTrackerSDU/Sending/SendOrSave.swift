//
//  SendOrSave.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 22/09/2018.
//

import Foundation

// APP USAGES
class SendOrSaveHandler {
    private var credentials : Credentials!
    
    init(credentials: Credentials) {
        self.credentials = credentials
    }
    
    func sendOrSaveUsage<T: Usage>(usage: T, fromPersistence: Bool) {
        var onSuccess : (() -> Void)
        var onError   : ((Error?) -> Void)?
        if fromPersistence {
            
            // Delete from Persistence, hoping that it will successfully be sent.
            // Ensures that the same usage aren't send multiple times while waiting for callback from request.
            Persistence.delete(usage)
            
            onSuccess = {
                Logging.logUsage(usage: usage, usageLogType: .sentFromPersistence)
            }
            onError = { _ in
                // Request did not succeed, so we save the usage again
                Persistence.save(usage)
            }
        } else {
            onSuccess = { Logging.logUsage(usage: usage, usageLogType: .sentDirectly) }
            onError = { _ in
                Persistence.save(usage)
                Logging.logUsage(usage: usage, usageLogType: .saved)
            }
        }
        
        let usageType = type(of: usage) == DeviceUsage.self ? UsageType.device : UsageType.app
        
        sendUsage(usage: usage, usageType: usageType, credentials: self.credentials, onSuccess: onSuccess, onError: onError)
    }
    
    func makeAndSendOrSaveDeviceUsage(eventType: EventType) {
        let deviceUsage = makeDeviceUsage(eventType: eventType)
        sendOrSaveUsage(usage: deviceUsage, fromPersistence: false)
    }
    
    @objc func sendSavedUsages() {
        let appUsages = Persistence.fetchAllAppUsages()
        let deviceUsages = Persistence.fetchAllDeviceUsages()
        
        appUsages.forEach    { appUsage in sendOrSaveUsage(usage: appUsage, fromPersistence: true) }
        deviceUsages.forEach { deviceUsage in sendOrSaveUsage(usage: deviceUsage, fromPersistence: true) }
    }
    
    
}
