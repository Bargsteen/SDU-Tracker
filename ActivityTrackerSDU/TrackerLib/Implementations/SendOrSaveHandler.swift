//
//  SendOrSaveHandler.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 22/09/2018.
//

import Foundation

class SendOrSaveHandler: SendOrSaveHandlerProtocol {
    private let logger: LoggerProtocol
    private let persistenceHandler: PersistenceHandlerProtocol
    private let requestHandler: RequestHandlerProtocol
    private let settings: SettingsProtocol
    
    private let credentials : Credentials
    
    
    init(logger: LoggerProtocol, persistenceHandler: PersistenceHandlerProtocol, requestHandler: RequestHandlerProtocol,
         settings: SettingsProtocol) {
        self.logger = logger
        self.persistenceHandler = persistenceHandler
        self.requestHandler = requestHandler
        self.settings = settings
        
        self.credentials = settings.credentials
    }
    
    func sendOrSaveUsage<T: Usage>(usage: T, fromPersistence: Bool) {
        var onSuccess : (() -> Void)
        var onError   : ((Error?) -> Void)?
        if fromPersistence {
            onSuccess = {
                self.logger.logUsage(usage: usage, usageLogType: .sentFromPersistence)
                self.persistenceHandler.delete(usage)
            }
            onError = nil // Nothing left to do
            
        } else {
            onSuccess = { self.logger.logUsage(usage: usage, usageLogType: .sentDirectly) }
            onError = { _ in
                self.persistenceHandler.save(usage)
                self.logger.logUsage(usage: usage, usageLogType: .saved)
            }
        }
        
        let usageType = type(of: usage) == DeviceUsage.self ? UsageType.device : UsageType.app
        
        requestHandler.sendUsage(usage: usage, usageType: usageType, credentials: self.credentials, onSuccess: onSuccess, onError: onError)
    }
    
    @objc func sendSomeSavedUsages(limitOfEach: Int) {
        // Fetch up to limitOfEach of app and devices usages and try to send them.
        // If any of the requests fail, they are put back into persistence.
        
        let appUsages = persistenceHandler.fetchAppUsages(upTo: limitOfEach)
        let deviceUsages = persistenceHandler.fetchDeviceUsages(upTo: limitOfEach)
        
        appUsages.forEach    { appUsage in sendOrSaveUsage(usage: appUsage, fromPersistence: true) }
        deviceUsages.forEach { deviceUsage in sendOrSaveUsage(usage: deviceUsage, fromPersistence: true) }
    }
    
    
}
