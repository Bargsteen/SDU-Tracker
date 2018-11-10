//
//  UrlSetupHandler.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 21/10/2018.
//

import Foundation
import CwlUtils
import LaunchAtLogin


class SetupHandler: SetupHandlerProtocol {
    
    private let alertHandler: AlertHandlerProtocol
    private let dateTimeHandler: DateTimeHandlerProtocol
    private var launchAtStartupHandler: LaunchAtLoginHandlerProtocol
    private let logger: LoggerProtocol
    private var settings: SettingsProtocol
    
    init(assembler: AssemblerProtocol) {
        self.alertHandler = assembler.resolve()
        self.dateTimeHandler = assembler.resolve()
        self.launchAtStartupHandler = assembler.resolve()
        self.logger = assembler.resolve()
        self.settings = assembler.resolve()
    }
    
    func parseUrlAndSetupApp(_ url : URL) -> Bool{
        // Parse queryItems from url to dict: ?key1=value1&key2=value2
        let maybeDict = parseUrlToDict(url)
        
        guard let dict = maybeDict else {logInvalidStartupUrl("Invalid data"); return false;}
        
        // Ensure dict has the necessary key-value pairs.
        guard let userId = dict["user_id"] else { logInvalidStartupUrl("Missing: user_id"); return false;}
        guard let usersString = dict["users"] else { logInvalidStartupUrl("Missing: users"); return false;}
        guard let trackingTypeString = dict["tracking_type"] else { logInvalidStartupUrl("Missing: tracking_type"); return false;}
        guard let measurementDaysString = dict["measurement_days"] else { logInvalidStartupUrl("Missing: measurement_days"); return false;}
        
        
        settings.userId = userId
        
        
        // Handle Users
        let userArray = parseUsers(usersString);
        if let userArray = userArray {
            userArray.forEach { user in settings.addUser(nameOfUser: user)}
            settings.currentUser = userArray.first ?? .unnamedUser
        } else {
            logInvalidStartupUrl("Invalid value: users")
            return false
        }
        
        
        // Handle TrackingType
        let trackingType: TrackingType = trackingTypeString == "1" ? .AppAndDevice : .Device
        settings.trackingType = trackingType
        
        // Handle MeasureMentDays
        if let measurementDays = Int(measurementDaysString) {
            // Today + measurement days
            let today = dateTimeHandler.now
            let stopTrackingDate = Calendar.current.date(byAdding: .day, value: measurementDays, to: today)!
            settings.stopTrackingDate = stopTrackingDate
        } else {
            logInvalidStartupUrl("Invalid value: mesaurement_days")
            return false
        }
        
        // Set app to launch automatically
        launchAtStartupHandler.launchAtStartupIsEnabled = true
        
        // If we got this far, everything should be fine.
        settings.appHasBeenSetup = true
        
        logger.logInfo("App is setup!")
        return true
    }
    
    
    func showSetupResultAlert(succeeded: Bool) {
        let alert = NSAlert()
        
        if(succeeded) {
            alert.messageText = "Opsætning færdiggjort"
            alert.informativeText = "Der er intet mere at gøre."
            alert.alertStyle = .informational
        } else {
            alert.messageText = "Opsætning mislykkedes"
            alert.informativeText = "Prøv at åbne linket igen. Hvis det ikke virker, så kontakt SDU."
            alert.alertStyle = .critical
        }
        alert.addButton(withTitle: "Ok")
        alert.runModal()
    }
    
    
    // Works like this (note the space after comma): "[user1, user2]" -> ["user1", "user2"]
    private func parseUsers(_ users : String) -> [String]? {
        if(users.first == "[" && users.last == "]"){
            let strippedOfBrackets = String(String(users.dropFirst()).dropLast())
            let users = strippedOfBrackets.components(separatedBy: ", ")
            if(!users.isEmpty && users.first != "") {
                return users
            }
        }
       return nil
    }
    
    private func logInvalidStartupUrl(_ reason: String) {
        logger.logError("Invalid startup url. \(reason)")
    }
    
    private func parseUrlToDict(_ url: URL) -> [String:String]? {
        var dict = [String:String]()
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        if let queryItems = components.queryItems {
            for item in queryItems {
                dict[item.name] = item.value!
            }
        }
        
        guard let base64data = dict["data"] else {logInvalidStartupUrl("Missing: Data"); return nil;}
        guard let data = base64data.fromBase64() else {logInvalidStartupUrl("Invalid Base64 Data"); return nil;}
        
        return convertJSONToDictionary(text: data)
    }
    
    private func convertJSONToDictionary(text: String) -> [String: String]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
