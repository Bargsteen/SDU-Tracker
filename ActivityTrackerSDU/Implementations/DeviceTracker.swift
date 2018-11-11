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
    private let userHandler: UserHandlerProtocol
    
    private var deviceTrackingIsEnabled: Bool
    
    init(dateTimeHandler: DateTimeHandlerProtocol, sendOrSaveHandler: SendOrSaveHandlerProtocol, settings: SettingsProtocol,
         userHandler: UserHandlerProtocol) {
        
        self.dateTimeHandler = dateTimeHandler
        self.sendOrSaveHandler = sendOrSaveHandler
        self.settings = settings
        self.userHandler = userHandler
        
        deviceTrackingIsEnabled = false
        settings.subscribeToUserChanges(self)
    }
    
    func startTracking() {
        deviceTrackingIsEnabled = true
        self.sendOrSaveHandler.sendOrSaveUsage(usage: makeDeviceUsage(eventType: .started), fromPersistence: false)
    }
    
    func stopTracking() {
        deviceTrackingIsEnabled = false
        self.sendOrSaveHandler.sendOrSaveUsage(usage: makeDeviceUsage(eventType: .ended), fromPersistence: false)
    }
    
    // This function handles manual user changes from the menu.
    func userChanged(previousUser: String, newUser: String) {
        
        // Previous user stopped using the device
        let identifierForPrevious = settings.makeParticipantIdentifierForSpecificUser(user: previousUser)
        let endedUsage = makeDeviceUsage(eventType: .ended, participantIdentifier: identifierForPrevious)
        sendOrSaveHandler.sendOrSaveUsage(usage: endedUsage, fromPersistence: false)
        
        // New user started using the device
        let identifierForNew = settings.makeParticipantIdentifierForSpecificUser(user: newUser)
        let startedUsage = makeDeviceUsage(eventType: .started, participantIdentifier: identifierForNew)
        sendOrSaveHandler.sendOrSaveUsage(usage: startedUsage, fromPersistence: false)
    }
    
    private func setupScreenNotificationObservers() {
        let notificationCenter = NSWorkspace.shared.notificationCenter
        
        // Handle waking aka Session start
        notificationCenter.addObserver(forName: NSWorkspace.screensDidWakeNotification, object: nil, queue: nil, using: {(n:Notification) in
            if(self.deviceTrackingIsEnabled) {
                self.userHandler.checkIfUserHasChanged()
                
                self.sendOrSaveHandler.sendOrSaveUsage(usage: self.makeDeviceUsage(eventType: .started), fromPersistence: false)
            }
        })
        
        // Handle sleeping aka Session end
        notificationCenter.addObserver(forName: NSWorkspace.screensDidSleepNotification, object: nil, queue: nil, using: {(n:Notification) in
            if(self.deviceTrackingIsEnabled) {
                self.sendOrSaveHandler.sendOrSaveUsage(usage: self.makeDeviceUsage(eventType: .ended), fromPersistence: false)
            }
        })
    }
    
    private func makeDeviceUsage(eventType: EventType) -> DeviceUsage {
        return makeDeviceUsage(eventType: eventType, participantIdentifier: settings.participantIdentifier);
    }
    
    private func makeDeviceUsage(eventType: EventType, participantIdentifier: String) -> DeviceUsage {
        let now = dateTimeHandler.now
        return DeviceUsage(participantIdentifier: participantIdentifier, deviceModelName: settings.deviceModelName,
                           timeStamp: now, userCount: settings.userCount, eventType: eventType)
    }
}
