//
//  DeviceTracker.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 04/11/2018.
//

import Foundation
import Cocoa

class DeviceTracker: DeviceTrackerProtocol, UserChangedDelegate {
    
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
        
        settings.subscribeToUserChanges(self)
    }
    
    func startTracking() {
        sendOrSaveHandler.sendOrSaveUsage(usage: usageBuilder.makeDeviceUsage(eventType: .started), fromPersistence: false)
    }
    
    func stopTracking() {
        sendOrSaveHandler.sendOrSaveUsage(usage: usageBuilder.makeDeviceUsage(eventType: .ended), fromPersistence: false)
    }
    
    // This function handles manual user changes from the menu.
    func userChanged(previousUser: String, newUser: String) {
        
        // Previous user stopped using the device
        let endedUsage = usageBuilder.makeDeviceUsage(eventType: .ended, user: previousUser)
        sendOrSaveHandler.sendOrSaveUsage(usage: endedUsage, fromPersistence: false)
        
        // New user started using the device
        let startedUsage = usageBuilder.makeDeviceUsage(eventType: .started, user: newUser)
        sendOrSaveHandler.sendOrSaveUsage(usage: startedUsage, fromPersistence: false)
    }
    
    private func setupScreenNotificationObservers() {
        let notificationCenter = NSWorkspace.shared.notificationCenter
        
        // Handle waking aka Session start
        notificationCenter.addObserver(forName: NSWorkspace.screensDidWakeNotification, object: nil, queue: nil, using: {(n:Notification) in
            self.userHandler.checkIfUserHasChanged()
                
            let deviceStartedUsage = self.usageBuilder.makeDeviceUsage(eventType: .started)
            self.sendOrSaveHandler.sendOrSaveUsage(usage: deviceStartedUsage, fromPersistence: false)
        })
        
        // Handle sleeping aka Session end
        notificationCenter.addObserver(forName: NSWorkspace.screensDidSleepNotification, object: nil, queue: nil, using: {(n:Notification) in
            let deviceEndedUsage = self.usageBuilder.makeDeviceUsage(eventType: .ended)
            self.sendOrSaveHandler.sendOrSaveUsage(usage: deviceEndedUsage, fromPersistence: false)
        })
    }
}
