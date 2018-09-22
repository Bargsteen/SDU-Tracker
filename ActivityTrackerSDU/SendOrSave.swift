//
//  SendOrSave.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 22/09/2018.
//

import Foundation

// APP USAGES

func maybeSendOldestSavedAppUsage(){
    if let credentials = loadCredentialsFromKeychain() {
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

// DEVICE USAGES

func maybeSendOldDeviceUsages(){
    if let credentials = loadCredentialsFromKeychain() {
        if let oldestDeviceUsage = Persistence.maybeFetchOldestDeviceUsage() {
            sendUsage(usage: oldestDeviceUsage, usageType: .device, credentials: credentials,
                      onSuccess: { Persistence.deleteDeviceUsage(oldestDeviceUsage.getIdentifier())},
                      onError: nil // TODO: Perhaps do nothing?
            )
        }
    }
}


func sendDeviceUsage(eventType: EventType){
    if let credentials = loadCredentialsFromKeychain() {
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
        sendUsage(usage: deviceUsage, usageType: .device, credentials: credentials, onSuccess:
            {
                maybeShowSentSavedNotification(shouldShow: shouldShowNotifications, usageType: .device, notificationType: .sent, usageDescription: usageDescription)
        }) { _ in
            maybeShowSentSavedNotification(shouldShow: shouldShowNotifications, usageType: .device, notificationType: .saved, usageDescription: usageDescription)
            Persistence.save(deviceUsage)
        }
    }
}

func makeDeviceUsage(eventType: EventType) -> DeviceUsage {
    let userCount = UserDefaultsHelper.getUserCount()
    let deviceModelName = UserDefaultsHelper.getDeviceModelName()
    let participantIdentifier = UserDefaultsHelper.getParticipantIdentifier()
    return DeviceUsage(participantIdentifier: participantIdentifier, eventType: eventType, timeStamp: Date(), userCount: userCount, deviceModelName: deviceModelName)
}
