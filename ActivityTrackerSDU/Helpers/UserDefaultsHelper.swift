//
//  UserDefaultsHelper.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 22/09/2018.
//

import Foundation

public class UserDefaultsHelper {
    
    // GETTERS
    static func getDefaults() -> UserDefaults {
        return UserDefaults.standard
    }
    
    static func getShowNotificationsSetting() -> Bool {
        return getDefaults().bool(forKey: .showNotificationsKey)
    }
    
    static func getUsers() -> [String] {
        return getDefaults().stringArray(forKey: .usersKey) ?? []
    }
    
    static func getUserCount() -> Int {
        let userCount = getUsers().count
        return userCount > 1 ? userCount : 1 // No users in list => 1 user
    }
    
    static func getCurrentUser() -> String {
        return getDefaults().string(forKey: .currentUserKey) ?? .unnamedUser
    }
    
    static func getDeviceModelName() -> String {
        return getDefaults().string(forKey: .deviceModelNameKey) ?? .unknownDevice
    }
    
    static func getUseAppTracking() -> Bool {
        return getDefaults().bool(forKey: .useAppTrackingKey)
    }
    
    static func getParticipantIdentifier() -> String {
        let credentials = CredentialHandler.loadCredentialsFromKeychain()
        let currentUser = getCurrentUser()
        if let credentials = credentials {
            return "\(credentials.username):\(currentUser)"
        }
        // This should never happen.
        // And the data can't be send to db, because no credentials exist.
        Logging.logError("Credentials not found.")
        return currentUser
    }
    
    
    // SETTERS
    
    static func setDeviceModelName(_ name: String) {
        getDefaults().setValue(name, forKey: .deviceModelNameKey)
    }
    
    static func setShowNotificationsSetting(_ newValue: Bool) {
        getDefaults().setValue(newValue, forKey: .showNotificationsKey)
    }
    
    static func setCurrentUser(_ newUser: String) {
        getDefaults().setValue(newUser, forKey: .currentUserKey)
    }
    
    static func setUsers(_ newUsers: [String]) {
        getDefaults().setValue(newUsers, forKey: .usersKey)
    }
    
    static func setUseAppTracking(_ newValue: Bool) {
        getDefaults().setValue(newValue, forKey: .useAppTrackingKey)
    }

}
