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
    
    var timeKeeper : TimeKeeper!
    var reachability : Reachability!
    var userHandler : UserHandler
    
    init(userHandler: UserHandler) {
        timeKeeper = TimeKeeper()
        reachability = Reachability()
        self.userHandler = userHandler
    }
    
    public func setupTracking() {
        if let credentials = CredentialHandler.loadCredentialsFromKeychain() {
            
            setUpDeviceUsageTracking(credentials: credentials)
            
            setupAppUsageTracking(credentials: credentials)
        }
    }
    
    private func setupAppUsageTracking(credentials: Credentials) {
        
        // When we have Internet
        reachability.whenReachable = { reachability in
            DispatchQueue.global(qos: .background).async {
                
                
                while(true) {
                    if(self.reachability.connection == Reachability.Connection.none) {
                        break
                    }
                    
                    // TODO: Only check DB if flag has been set to do so
                    //self.maybeSendOldestSavedAppUsage()
                    //self.maybeSendOldDeviceUsages()
                    
                    
                    if UserDefaultsHelper.getUseAppTracking() {
                        if let lastAppUsage = self.maybeGetLastAppUsage() {
                            tryToSendAppUsage(appUsage: lastAppUsage, credentials: credentials)
                        }
                    }
                    sleep(1)
                }
            }
        }
        
        // When we don't have internet
        reachability.whenUnreachable = { _ in
            DispatchQueue.global(qos: .background).async {
                while(true) {
                    if(self.reachability.connection != Reachability.Connection.none) {
                        break
                    }
                    
                    if UserDefaultsHelper.getUseAppTracking() {
                        if let lastAppUsage = self.maybeGetLastAppUsage() {
                            let usageDescription = "\(lastAppUsage.package) i \(lastAppUsage.duration) ms"
                            maybeShowSentSavedNotification(shouldShow: UserDefaultsHelper.getShowNotificationsSetting(), usageType: .app, notificationType: .saved, usageDescription: usageDescription)
                            Persistence.save(lastAppUsage)
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
        sendDeviceUsage(eventType: .started)
        
        let notificationCenter = NSWorkspace.shared.notificationCenter
        
        // Handle waking aka Session start
        notificationCenter.addObserver(forName: NSWorkspace.screensDidWakeNotification, object: nil, queue: nil, using: {(n:Notification) in
            
            self.userHandler.maybeAskAndSetCorrectUser()
            
            sendDeviceUsage(eventType: EventType.started)
        })
        
        // Handle sleeping aka Session end
        notificationCenter.addObserver(forName: NSWorkspace.screensDidSleepNotification, object: nil, queue: nil, using: {(n:Notification) in
            sendDeviceUsage(eventType: EventType.ended)
            
            // Send an appUsage for currentWindow when the computer goes to sleep.
            // Otherwise it will count the sleeping time into the duration of the appUsage
            if(UserDefaultsHelper.getUseAppTracking()){
                if let activeWindow = self.timeKeeper.maybeTerminateAndGetCurrentActiveWindow() {
                    let appUsage = makeAppUsage(activeWindow: activeWindow)
                    tryToSendAppUsage(appUsage: appUsage, credentials: credentials)
                }
            }
            
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
