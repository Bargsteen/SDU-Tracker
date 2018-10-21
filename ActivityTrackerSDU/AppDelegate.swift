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
class AppDelegate: NSObject, NSApplicationDelegate{
    var sendOrSaveHandler : SendOrSaveHandler?
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        Logging.setupLogger()
        
        UserDefaultsHelper.setAppHasBeenSetup(false)
        
        // Subscribe to open by url event
        NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(AppDelegate.handleGetURLEvent(_:withReplyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
        
        if(UserDefaultsHelper.getAppHasBeenSetup()){
            begin()
        }else {
            Logging.logInfo("App has not been setup.")
        }
    }
    
    @objc func handleGetURLEvent(_ event: NSAppleEventDescriptor!, withReplyEvent:NSAppleEventDescriptor!) {
        let url = URL(string: event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))!.stringValue!)!
        
        
        let readyForFirstBegin = SetupHandler.parseUrlAndSetupApp(url)
        if(readyForFirstBegin){
            begin()
        } else {
            exit(1)
        }
    }
    
    
    func begin() {
        let today = Date()
        
        if(UserDefaultsHelper.getStopTrackingDate() >= today) {
            
            // Credentials
            if let credentials = CredentialsHandler.loadCredentialsFromKeychain() {
                self.sendOrSaveHandler = SendOrSaveHandler(credentials: credentials)
            } else {
                // Should never happen. But keychain could be deleted from outside.
                
                // TODO: Request user to resetup app with the link
                Logging.logError("AppDelegate applicationDidFinishLaunching: No credentials.")
                exit(1)
            }
            
            // Correct User
            UserHandler.sharedInstance.maybeAskAndSetCorrectUser()
            
            // Tracking
            let tracking = Tracking(userHandler: UserHandler.sharedInstance, sendOrSaveHandler: sendOrSaveHandler!)
            tracking.setupTracking()
        } else {
            // TODO: Check if there are saved entries in db.
            
            Logging.logInfo("Tracking date has been reached. Disabling Launch at Login and terminating app.")
            LaunchAtLogin.isEnabled = false
            exit(0)
        }
    }

    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        if(UserDefaultsHelper.getAppHasBeenSetup()){
            self.sendOrSaveHandler?.makeAndSendOrSaveDeviceUsage(eventType: .ended)
        }
        
        sleep(1)
        return .terminateNow
    }
}


