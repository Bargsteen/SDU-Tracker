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
class AppDelegate: NSObject {
    var sendOrSaveHandler : SendOrSaveHandler?
    
    override init() {
        LaunchAtLogin.isEnabled = true
        Logging.setupLogger()
        
        CredentialsHandler.ensureCredentialsAreSet()
        
        UserDefaultsHelper.setDeviceModelName(Sysctl.model)
        
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
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        UserHandler.sharedInstance.maybeAskAndSetCorrectUser()
        
        let tracking = Tracking(userHandler: UserHandler.sharedInstance, sendOrSaveHandler: sendOrSaveHandler!)
        tracking.setupTracking()
    }
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        self.sendOrSaveHandler?.makeAndSendOrSaveDeviceUsage(eventType: .ended)
        sleep(1)
        return .terminateNow
    }
}


