//
//  DeviceTracker.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 04/11/2018.
//

import Foundation
import Cocoa

class DeviceTracker: DeviceTrackerProtocol {
    private let dateTimeHandler: DateTimeHandlerProtocol
    private let sendOrSaveHandler: SendOrSaveHandlerProtocol
    private let settings: SettingsProtocol
    private let userHandler: UserHandlerProtocol
    
    private var deviceTrackingIsEnabled: Bool
    
    init(assembler: AssemblerProtocol) {
        self.dateTimeHandler = assembler.resolve()
        self.sendOrSaveHandler = assembler.resolve()
        self.settings = assembler.resolve()
        self.userHandler = assembler.resolve()
        
        deviceTrackingIsEnabled = false
    }
    
    func startTracking() {
        deviceTrackingIsEnabled = true
        self.sendOrSaveHandler.sendOrSaveUsage(usage: makeDeviceUsage(eventType: .started), fromPersistence: false)
    }
    
    func stopTracking() {
        deviceTrackingIsEnabled = false
        self.sendOrSaveHandler.sendOrSaveUsage(usage: makeDeviceUsage(eventType: .ended), fromPersistence: false)
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
        let now = dateTimeHandler.now
        return DeviceUsage(participantIdentifier: settings.participantIdentifier, deviceModelName: settings.deviceModelName,
                           timeStamp: now, userCount: settings.userCount, eventType: eventType)
    }
}
