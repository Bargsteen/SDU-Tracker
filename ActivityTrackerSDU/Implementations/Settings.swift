//
//  Settings.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 04/11/2018.
//

import Foundation
import CwlUtils

class Settings: SettingsProtocol {
    
    private let dateTimeHandler: DateTimeHandlerProtocol
    private var appHasBeenSetupChangedSubscribers: [AppHasBeenSetupDelegate]
    
    init(dateTimeHandler: DateTimeHandlerProtocol) {
        self.dateTimeHandler = dateTimeHandler
        self.appHasBeenSetupChangedSubscribers = []
    }
    
    var appHasBeenSetup: Bool {
        get {
            return userDefaults.bool(forKey: appHasBeenSetupKey)
        }
        set {
            userDefaults.set(newValue, forKey: appHasBeenSetupKey)
            notifySubscribers(value: newValue)
        }
    }
    
    func subscribeToAppHasBeenSetupChanges(subscriber: AppHasBeenSetupDelegate) {
        appHasBeenSetupChangedSubscribers.append(subscriber)
    }
    
    private func notifySubscribers(value: Bool){
        appHasBeenSetupChangedSubscribers.forEach { s in s.onAppHasBeenSetupChanged(value: value) }
    }
    
    var userList: [String] {
        get {
            let userList = userDefaults.stringArray(forKey: userListKey)
            if let userList = userList {
                return userList
            } else {
                userDefaults.set([], forKey: userListKey)
                return []
            }
        } set {
            userDefaults.set(newValue, forKey: userListKey)
        }
    }
    
    var userCount: Int {
        get {
            return self.userList.count
        }
    }
    
    var currentUser: String {
        get {
            return userDefaults.string(forKey: currentUserKey) ?? "ukendt-bruger"
        }
        set {
            if(!userList.contains(newValue)) {
                fatalError("Invalid currentUser. Not in userList.")
            }
            userDefaults.setValue(newValue, forKey: currentUserKey)
        }
    }

    var deviceModelName: String {
        get {
            return Sysctl.model
        }
    }
    
    var trackingType: TrackingType {
        // Uses rawValues, because UserDefaults can't store enums directly.
        get {
            let trackingTypeRawValue = userDefaults.integer(forKey: trackingTypeKey)
            let trackingType = TrackingType(rawValue: trackingTypeRawValue) ?? .Device
            return trackingType
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: trackingTypeKey)
        }
    }
    
    var stopTrackingDate: Date {
        get {
            let dateFound = userDefaults.value(forKey: stopTrackingDateKey) as? Date
            if let dateFound = dateFound {
                return dateFound
            } else {
                return self.dateTimeHandler.now
            }
        }
        set {
            userDefaults.set(newValue, forKey: stopTrackingDateKey)
        }
    }
    
    var userId: String {
        get {
            return userDefaults.string(forKey: userIdKey) ?? "ukendt-id"
        }
        set {
            userDefaults.set(newValue, forKey: userIdKey)
        }
    }
    
    var participantIdentifier: String {
        get {
            return makeParticipantIdentifierForSpecificUser(user: currentUser)
        }
    }
    
    func makeParticipantIdentifierForSpecificUser(user: String) -> String {
        return "\(userId):\(user)"
    }
    
    var credentials: Credentials {
        get {
            return Credentials(username: "***REMOVED***", password: "***REMOVED***")
        }
    }

    private let userDefaults = UserDefaults.standard
    
    private let appHasBeenSetupKey = "appHasBeenSetup"
    private let userListKey = "userList"
    private let stopTrackingDateKey = "stopTrackingData"
    private let userIdKey = "userId"
    private let trackingTypeKey = "trackingType"
    private let currentUserKey = "currentUser"
}
