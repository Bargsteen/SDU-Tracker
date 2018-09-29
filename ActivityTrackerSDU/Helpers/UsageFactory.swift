//
//  UsageFactory2.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 29/09/2018.
//

import Foundation

func makeDeviceUsage(eventType: EventType) -> DeviceUsage {
    let userCount = UserDefaultsHelper.getUserCount()
    let deviceModelName = UserDefaultsHelper.getDeviceModelName()
    let participantIdentifier = UserDefaultsHelper.getParticipantIdentifier()
    return DeviceUsage(participantIdentifier: participantIdentifier, eventType: eventType, timeStamp: Date(), userCount: userCount, deviceModelName: deviceModelName)
}

func makeAppUsage(activeWindow: ActiveWindowTime) -> AppUsage {
    let participantIdentifier = UserDefaultsHelper.getParticipantIdentifier()
    let deviceModelName = UserDefaultsHelper.getDeviceModelName()
    let duration = activeWindow.endTime?.timeIntervalSince(activeWindow.startTime) ?? 0
    return AppUsage(participantIdentifier: participantIdentifier, timeStamp: Date(), userCount: UserDefaultsHelper.getUserCount(), deviceModelName: deviceModelName, package: activeWindow.bundleIdentifier, duration: duration.toMilliseconds())
}
