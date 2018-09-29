//
//  Tracking.swift
//  ActivityTracker
//
//  Created by Kasper Dissing Bargsteen on 27/09/2018.
//

import Foundation
import Reachability
import Cocoa

class Tracking {
    
    var timeKeeper : TimeKeeper
    var reachability : Reachability!
    var userHandler : UserHandler
    var sendOrSaveHandler : SendOrSaveHandler
    
    init(userHandler: UserHandler, sendOrSaveHandler: SendOrSaveHandler) {
        timeKeeper = TimeKeeper()
        reachability = Reachability()
        self.sendOrSaveHandler = sendOrSaveHandler
        self.userHandler = userHandler
    }
    
    public func setupTracking() {
        if let credentials = CredentialsHandler.loadCredentialsFromKeychain() {
            
            setUpDeviceUsageTracking(credentials: credentials)
            
            setupAppUsageTracking(credentials: credentials)
        }
    }
    
    private func setupAppUsageTracking(credentials: Credentials) {
        var timer = 0
        
        // When we have Internet
        reachability.whenReachable = { reachability in
            DispatchQueue.global(qos: .background).async {
                while(true) {
                    if(self.reachability.connection == Reachability.Connection.none) {
                        Logging.logInfo("Lost internet connection.")
                        break
                    }
                    
                    timer = timer + 1
                    
                    if(timer >= .sendSavedUsagesInterval){
                        timer = 0
                        self.sendOrSaveHandler.sendSavedUsages()
                    }
                   
                    
                    if UserDefaultsHelper.getUseAppTracking() {
                        if let lastAppUsage = self.maybeGetLastAppUsage() {
                            self.sendOrSaveHandler.sendOrSaveUsage(usage: lastAppUsage, fromPersistence: false)
                        }
                    }
                    sleep(1) // 1 second
                }
            }
        }
        
        // When we don't have internet
        reachability.whenUnreachable = { _ in
            DispatchQueue.global(qos: .background).async {
                while(true) {
                    if(self.reachability.connection != Reachability.Connection.none) {
                        Logging.logInfo("Regained internet connection.")
                        break
                    }
                    
                    if UserDefaultsHelper.getUseAppTracking() {
                        if let lastAppUsage = self.maybeGetLastAppUsage() {
                            Persistence.save(lastAppUsage)
                            Logging.logUsage(usage: lastAppUsage, usageLogType: .saved)
                        }
                    }
                    
                    // Wait one second before trying to get the app usage.
                    // Could perhaps be handled by an event listener.
                    sleep(1)
                }
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            Logging.logError("Unable to start reachability notifier: \(error)")
        }
    }
    
    private func setUpDeviceUsageTracking(credentials: Credentials) {
        
        // Send initial start event
        self.sendOrSaveHandler.makeAndSendOrSaveDeviceUsage(eventType: .started)
        
        let notificationCenter = NSWorkspace.shared.notificationCenter
        
        // Handle waking aka Session start
        notificationCenter.addObserver(forName: NSWorkspace.screensDidWakeNotification, object: nil, queue: nil, using: {(n:Notification) in
            
            self.userHandler.maybeAskAndSetCorrectUser()
            
            self.sendOrSaveHandler.makeAndSendOrSaveDeviceUsage(eventType: .started)
        })
        
        // Handle sleeping aka Session end
        notificationCenter.addObserver(forName: NSWorkspace.screensDidSleepNotification, object: nil, queue: nil, using: {(n:Notification) in
            self.sendOrSaveHandler.makeAndSendOrSaveDeviceUsage(eventType: .ended)
            
//            // Send an appUsage for currentWindow when the computer goes to sleep.
//            // Otherwise it will count the sleeping time into the duration of the appUsage
//            if(UserDefaultsHelper.getUseAppTracking()){
//                if let activeWindow = self.timeKeeper.maybeTerminateAndGetCurrentActiveWindow() {
//                    let appUsage = makeAppUsage(activeWindow: activeWindow)
//                    self.sendOrSaveHandler.sendOrSaveUsage(usage: appUsage, fromPersistence: false)
//                }
//            }
            
        })
    }
    
    private func maybeGetLastAppUsage() -> AppUsage? {
        let activeWindow = self.timeKeeper.maybeGetLastActiveWindow()
        if let activeWindow = activeWindow {
            return makeAppUsage(activeWindow: activeWindow)
        }
        return nil
    }
    
}
