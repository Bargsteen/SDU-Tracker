//
//  AppDelegate.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 17/08/2018.
//

import Cocoa
import ServiceManagement
import LaunchAtLogin
import CwlUtils

@NSApplicationMain
class AppDelegate: NSObject{
    var sendOrSaveHandler : SendOrSaveHandler?
    
    override init() {
        LaunchAtLogin.isEnabled = true
        Logging.setupLogger()
        
        UserDefaultsHelper.setDeviceModelName(Sysctl.model)
        
        let credentialsFromKeychain = CredentialsHandler.loadCredentialsFromKeychain()
        
        if credentialsFromKeychain == nil {
            do {
                let creds = Credentials(username: "***REMOVED***", password: "***REMOVED***")
                try CredentialsHandler.saveCredentialsToKeychain(credentials: creds)
            } catch {
                Logging.logError("Credential save error: \(error)")
                CredentialsHandler.ensureCredentialsAreSet()
            }
        }
        
        
        let credentials = CredentialsHandler.loadCredentialsFromKeychain()
        
        if let credentials = credentials {
            
            self.sendOrSaveHandler = SendOrSaveHandler(credentials: credentials)
            
        } else {
            
            Logging.logError("AppDelegate applicationDidFinishLaunching: No credentials.")
            exit(1)
        }
    }
}


extension AppDelegate: NSApplicationDelegate {
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(AppDelegate.handleGetURLEvent(_:withReplyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        UserHandler.sharedInstance.maybeAskAndSetCorrectUser()
        
        let tracking = Tracking(userHandler: UserHandler.sharedInstance, sendOrSaveHandler: sendOrSaveHandler!)
        tracking.setupTracking()
    }
    
    @objc func handleGetURLEvent(_ event: NSAppleEventDescriptor!, withReplyEvent:NSAppleEventDescriptor!) {
        let url = URL(string: event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))!.stringValue!)!
        
        var dict = [String:String]()
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        if let queryItems = components.queryItems {
            for item in queryItems {
                dict[item.name] = item.value!
            }
        }
        
        
        
        Logging.logInfo("THE URL DICT: \(dict)")
    }
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        self.sendOrSaveHandler?.makeAndSendOrSaveDeviceUsage(eventType: .ended)
        sleep(1)
        return .terminateNow
    }
}


