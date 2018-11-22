//
//  UsageBuilder.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 06/11/2018.
//

import Foundation


class UsageBuilder: UsageBuilderProtocol {
    private let dateTimeHandler: DateTimeHandlerProtocol
    private let settings: SettingsProtocol
    
    init(dateTimeHandler: DateTimeHandlerProtocol, settings: SettingsProtocol) {
        self.dateTimeHandler = dateTimeHandler
        self.settings = settings
    }
    func makeDeviceUsage(eventType: EventType) -> DeviceUsage {
        
        let deviceModelName = settings.deviceModelName
        let now = dateTimeHandler.now
        let participantIdentifier = settings.participantIdentifier
        let userCount = settings.userCount
        
        return DeviceUsage(participantIdentifier: participantIdentifier, deviceModelName: deviceModelName,
                           timeStamp: now, userCount: userCount, eventType: eventType)
    }
    
    func makeDeviceUsage(eventType: EventType, user: String) -> DeviceUsage {
        
        let participantIdentifier = settings.makeParticipantIdentifierForSpecificUser(user: user)
        let now = dateTimeHandler.now
        
        return DeviceUsage(participantIdentifier: participantIdentifier, deviceModelName: settings.deviceModelName,
                           timeStamp: now, userCount: settings.userCount, eventType: eventType)
    }
    
    
    
    func makeAppUsage(activeWindow: ActiveWindow) -> AppUsage {
        
        let deviceModelName = settings.deviceModelName
        let now = dateTimeHandler.now
        let participantIdentifier = settings.participantIdentifier
        let duration = activeWindow.endTime?.timeIntervalSince(activeWindow.startTime) ?? 0
        let userCount = settings.userCount
        
        return AppUsage(participantIdentifier: participantIdentifier, deviceModelName: deviceModelName, timeStamp: now, userCount: userCount,
                        package: activeWindow.bundleIdentifier, duration: Int(duration.toMilliseconds()))
    }
    
    
}
