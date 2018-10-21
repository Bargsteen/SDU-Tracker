//
//  UrlSetupHandler.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 21/10/2018.
//

import Foundation
import CwlUtils
import LaunchAtLogin


class SetupHandler {
    public static func parseUrlAndSetupApp(_ url : URL) -> Bool{
        
        // Parse queryItems from url to dict: ?key1=value1&key2=value2
        let dict = parseUrlToDict(url)
        
        
        // Ensure dict has the necessary key-value pairs. /?username=uname&password=secret&users=[user1, user2]&tracking_type=0&measurement_days=365
        guard let username = dict["username"] else { logInvalidStartupUrl("Missing: username"); return false;}
        guard let password = dict["password"] else { logInvalidStartupUrl("Missing: password"); return false;}
        guard let usersString = dict["users"] else { logInvalidStartupUrl("Missing: users"); return false;}
        guard let trackingTypeString = dict["tracking_type"] else { logInvalidStartupUrl("Missing: tracking_type"); return false;}
        guard let measurementDaysString = dict["measurement_days"] else { logInvalidStartupUrl("Missing: measurement_days"); return false;}
        
        
        // Handle Credentials
        let credentials = Credentials(username: username, password: password)
        do {
            // Only necessary when setup is being run several times. Primarily needed during development.
            if let _ = CredentialsHandler.loadCredentialsFromKeychain() {
                try CredentialsHandler.deleteCredentialsFromKeychain()
            }
            try CredentialsHandler.saveCredentialsToKeychain(credentials: credentials)
        } catch {
            Logging.logError("Could not save credentials from URL: \(error)")
            return false
        }
        
        
        // Handle Users
        let userArray = parseUsers(usersString);
        if let userArray = userArray {
            UserDefaultsHelper.setUsers(userArray)
            UserDefaultsHelper.setCurrentUser(userArray.first!)
        } else {
            logInvalidStartupUrl("Invalid value: users")
            return false
        }
        
        
        // Handle TrackingType
        let trackingTypeBool = trackingTypeString == "1" ? true : false
        UserDefaultsHelper.setUseAppTracking(trackingTypeBool)
        
        
        // Handle MeasureMentDays
        if let measurementDays = Int(measurementDaysString) {
            // Today + measurement days
            let stopTrackingDate = Calendar.current.date(byAdding: .day, value: measurementDays, to: Date())!
            UserDefaultsHelper.setStopTrackingDate(stopTrackingDate)
        } else {
            logInvalidStartupUrl("Invalid value: mesaurement_days")
            return false
        }
        
        
        doAdditionalInitialSetup()
        
        // If we got this far, everything should be fine.
        UserDefaultsHelper.setAppHasBeenSetup(true)
        Logging.logInfo("App is setup!")
        return true
    }
    
    private static func doAdditionalInitialSetup() {
        LaunchAtLogin.isEnabled = true
        UserDefaultsHelper.setDeviceModelName(Sysctl.model)
    }
    
    
    // Works like this (note the space after comma): "[user1, user2]" -> ["user1", "user2"]
    private static func parseUsers(_ users : String) -> [String]? {
        if(users.first == "[" && users.last == "]"){
            let strippedOfBrackets = String(String(users.dropFirst()).dropLast())
            let users = strippedOfBrackets.components(separatedBy: ", ")
            if(!users.isEmpty && users.first != "") {
                return users
            }
        }
       return nil
    }
    
    private static func logInvalidStartupUrl(_ reason: String) {
        Logging.logError("Invalid startup url. \(reason)")
    }
    
    private static func parseUrlToDict(_ url: URL) -> [String:String] {
        var dict = [String:String]()
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        if let queryItems = components.queryItems {
            for item in queryItems {
                dict[item.name] = item.value!
            }
        }
        return dict
    }
    

}
