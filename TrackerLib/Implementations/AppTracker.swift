//
//  AppTracker.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 04/11/2018.
//

import Foundation
import Reachability

class AppTracker: AppTrackerProtocol {
    private let activeWindowHandler: ActiveWindowHandlerProtocol
    private let logger: LoggerProtocol
    private let sendOrSaveHandler: SendOrSaveHandlerProtocol
    private let persistenceHandler: PersistenceHandlerProtocol
    private let usageBuilder: UsageBuilderProtocol
    
    private let reachability: Reachability
    
    private var appTrackingIsEnabled: Bool
    
    init(assembler: AssemblerProtocol){
        self.activeWindowHandler = assembler.resolve()
        self.logger = assembler.resolve()
        self.sendOrSaveHandler = assembler.resolve()
        self.persistenceHandler = assembler.resolve()
        self.usageBuilder = assembler.resolve()
        
        // TODO: Make a protocol for this one
        self.reachability = Reachability()!
        
        self.appTrackingIsEnabled = false
    }
    
    func startTracking() {
        appTrackingIsEnabled = true
    }
    
    func stopTracking() {
        appTrackingIsEnabled = false
    }
    
    private func setupAppUsageTracking(credentials: Credentials) {
        var timer : UInt32 = 0
        
        // When we have Internet
        reachability.whenReachable = { reachability in
            DispatchQueue.global(qos: .background).async {
                while(true) {
                    if(self.reachability.connection == Reachability.Connection.none) {
                        break
                    }
                    
                    timer = timer + .appTrackingInterval
                    
                    if(timer >= .sendSavedUsagesInterval){
                        timer = 0
                        self.sendOrSaveHandler.sendSomeSavedUsages(limitOfEach: 10)
                    }
                    
                    if self.appTrackingIsEnabled {
                        if let lastAppUsage = self.maybeGetLastAppUsage() {
                            self.sendOrSaveHandler.sendOrSaveUsage(usage: lastAppUsage, fromPersistence: false)
                        }
                    }
                    sleep(.appTrackingInterval)
                }
            }
        }
        
        // When we don't have internet
        reachability.whenUnreachable = { _ in
            DispatchQueue.global(qos: .background).async {
                while(true) {
                    if(self.reachability.connection != Reachability.Connection.none) {
                        self.logger.logInfo("Regained internet connection.")
                        break
                    }
                    
                    if self.appTrackingIsEnabled {
                        if let lastAppUsage = self.maybeGetLastAppUsage() {
                            self.persistenceHandler.save(lastAppUsage)
                            self.logger.logUsage(usage: lastAppUsage, usageLogType: .saved)
                        }
                    }
                    
                    // Wait one second before trying to get the app usage.
                    // Could perhaps be handled by an event listener.
                    sleep(.appTrackingInterval)
                }
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
             logger.logError("Unable to start reachability notifier: \(error)")
        }
    }
    
    private func maybeGetLastAppUsage() -> AppUsage? {
        let activeWindow = self.activeWindowHandler.maybeGetLastActiveWindow()
        if let activeWindow = activeWindow {
            
            return usageBuilder.makeAppUsage(activeWindow: activeWindow)
        }
        return nil
    }
    
    
}
