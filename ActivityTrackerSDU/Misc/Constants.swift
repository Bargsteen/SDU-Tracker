//
//  Constants.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 31/08/2018.
//

import Foundation


extension String {
    // Requests
    static let server = "screens.sdu.dk"
    static let devicePath = "/v1/device_usages"
    static let appPath = "/v1/app_usages"
    
    // Default values
    static let unnamedUser = "unavngivet-bruger"
    static let unknownApp = "ukendt-applikation"
    static let unknownDevice = "ukendt-apparat"
    
    // Menu strings
    static let trackingAppData = "Tracker: App + Tid"
    static let trackingDeviceData = "Tracker: Tid"
    
    static let notificationsEnabled = "Notifikationer: Til"
    static let notificationsDisabled = "Notifikationer: Fra"
    
    // UserDefaults keys
    static let currentUserKey = "currentUser"
    static let showNotificationsKey = "showNotifications"
    static let usersKey = "users"
    static let useAppTrackingKey = "useAppTracking"
    static let deviceModelNameKey = "deviceModelName"
}

extension Int {
    static let minWindowArea = 1000
    static let sendSavedUsagesInterval = 60 // seconds
}
