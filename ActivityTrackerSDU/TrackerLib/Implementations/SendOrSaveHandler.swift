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
    
    
    init(assembler: AssemblerProtocol) {
        self.logger = assembler.resolve()
        self.persistenceHandler = assembler.resolve()
        self.requestHandler = assembler.resolve()
        self.settings = assembler.resolve()
        
        self.credentials = settings.credentials
    }
    
    func sendOrSaveUsage<T: Usage>(usage: T, fromPersistence: Bool) {
        var onSuccess : (() -> Void)
        var onError   : ((Error?) -> Void)?
        if fromPersistence {
            
            // Delete from Persistence, hoping that it will successfully be sent.
            // Ensures that the same usage aren't send multiple times while waiting for callback from request.
            persistenceHandler.delete(usage)
            
            onSuccess = {
                self.logger.logUsage(usage: usage, usageLogType: .sentFromPersistence)
            }
            onError = { _ in
                // Request did not succeed, so we save the usage again
                self.persistenceHandler.save(usage)
            }
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
        
        let appUsages = persistenceHandler.fetchAppUsages()
        let deviceUsages = persistenceHandler.fetchDeviceUsages()
        
        // .prefix is bounds safe
        appUsages?.prefix(limitOfEach).forEach    { appUsage in sendOrSaveUsage(usage: appUsage, fromPersistence: true) }
        deviceUsages?.prefix(limitOfEach).forEach { deviceUsage in sendOrSaveUsage(usage: deviceUsage, fromPersistence: true) }
    }
    
    
}
