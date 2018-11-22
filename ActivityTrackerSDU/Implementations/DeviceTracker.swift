//
//  DeviceTracker.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 04/11/2018.
//

import Foundation
import Cocoa

class DeviceTracker: DeviceTrackerProtocol, UserSessionChangesDelegate {
    
    private let dateTimeHandler: DateTimeHandlerProtocol
    private let sendOrSaveHandler: SendOrSaveHandlerProtocol
    private let settings: SettingsProtocol
    private let usageBuilder: UsageBuilderProtocol
    private let userHandler: UserHandlerProtocol
    
    init(dateTimeHandler: DateTimeHandlerProtocol, sendOrSaveHandler: SendOrSaveHandlerProtocol, settings: SettingsProtocol,
         usageBuilder: UsageBuilderProtocol, userHandler: UserHandlerProtocol) {
        
        self.dateTimeHandler = dateTimeHandler
        self.sendOrSaveHandler = sendOrSaveHandler
        self.settings = settings
        self.usageBuilder = usageBuilder
        self.userHandler = userHandler
        
        
    }
    
    func startTracking() {
        setupScreenNotificationObservers()
        userHandler.subscribeToUserSessionChanges(self)
        
        // Initial check
        userHandler.checkIfUserHasChanged()
    }
    
    func stopTracking() {
        onUserSessionStarted(user: settings.currentUser)
        
        // TODO: Remove notifiers again. Might be unnecessary, since the app closes after this is called.
    }
    
    func onUserSessionStarted(user: String){
        let deviceStartedUsage = usageBuilder.makeDeviceUsage(eventType: .started, user: user)
        sendOrSaveHandler.sendOrSaveUsage(usage: deviceStartedUsage, fromPersistence: false)
    }
    
    func onUserSessionEnded(user: String){
        let deviceEndedUsage = usageBuilder.makeDeviceUsage(eventType: .ended, user: user)
        sendOrSaveHandler.sendOrSaveUsage(usage: deviceEndedUsage, fromPersistence: false)
    }
    
    private func setupScreenNotificationObservers() {
        let notificationCenter = NSWorkspace.shared.notificationCenter
        
        // Handle waking aka Session start
        notificationCenter.addObserver(forName: NSWorkspace.screensDidWakeNotification, object: nil, queue: nil, using: {(n:Notification) in
            
            // Userhandler invokes the correct events to send deviceStart/end
            self.userHandler.checkIfUserHasChanged()
        })
        
        // Handle sleeping aka Session end
        notificationCenter.addObserver(forName: NSWorkspace.screensDidSleepNotification, object: nil, queue: nil, using: {(n:Notification) in
            self.onUserSessionEnded(user: self.settings.currentUser)
        })
    }
}
