//
//  SendOrSave.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 22/09/2018.
//

import Foundation

// APP USAGES

func maybeSendOldestSavedAppUsage(){
    if let credentials = CredentialHandler.loadCredentialsFromKeychain() {
        if let oldestAppUsage = Persistence.maybeFetchOldestAppUsage() {
            sendUsage(usage: oldestAppUsage, usageType: .app, credentials: credentials,
                      onSuccess: {
                        Persistence.deleteAppUsage(oldestAppUsage.getIdentifier())
            },
                      onError: nil // TODO: Perhaps do nothing?
            )
        }
    }
}

func tryToSendAppUsage(appUsage: AppUsage, credentials: Credentials) {
    let usageDescription = "\(appUsage.package) i \(appUsage.duration) ms"
    sendUsage(usage: appUsage, usageType: .app, credentials: credentials
        , onSuccess: {
            maybeShowSentSavedNotification(shouldShow: UserDefaultsHelper.getShowNotificationsSetting(), usageType: .app, notificationType: .sent, usageDescription: usageDescription)
    }
        , onError: { _ in
            maybeShowSentSavedNotification(shouldShow: UserDefaultsHelper.getShowNotificationsSetting(), usageType: .app, notificationType: .saved, usageDescription: usageDescription)
            Persistence.save(appUsage) }
    )
}

// DEVICE USAGES

func maybeSendOldDeviceUsages(){
    if let credentials = CredentialHandler.loadCredentialsFromKeychain() {
        if let oldestDeviceUsage = Persistence.maybeFetchOldestDeviceUsage() {
            sendUsage(usage: oldestDeviceUsage, usageType: .device, credentials: credentials,
                      onSuccess: { Persistence.deleteDeviceUsage(oldestDeviceUsage.getIdentifier())},
                      onError: nil // TODO: Perhaps do nothing?
            )
        }
    }
}


func sendDeviceUsage(eventType: EventType){
    if let credentials = CredentialHandler.loadCredentialsFromKeychain() {
        let shouldShowNotifications = UserDefaultsHelper.getShowNotificationsSetting()
        let deviceUsage = makeDeviceUsage(eventType: eventType)
        
        var eventTypeString = ""
        switch eventType {
        case .started:
            eventTypeString = "Påbegyndt:"
        case .ended:
            eventTypeString = "Afsluttet:"
        }
        
        let usageDescription = "\(eventTypeString) \(deviceUsage.timeStamp)"
        sendUsage(usage: deviceUsage, usageType: .device, credentials: credentials,
            onSuccess: {
                maybeShowSentSavedNotification(shouldShow: shouldShowNotifications, usageType: .device, notificationType: .sent, usageDescription: usageDescription)
            },
            onError: { _ in
            maybeShowSentSavedNotification(shouldShow: shouldShowNotifications, usageType: .device, notificationType: .saved, usageDescription: usageDescription)
            Persistence.save(deviceUsage)
            }
        )
    }
}

// Make helpers

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
