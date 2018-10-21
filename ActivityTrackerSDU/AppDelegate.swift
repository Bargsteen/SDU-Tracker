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
        
        /*NSAppleEventManager *appleEventManager = [NSAppleEventManager sharedAppleEventManager];
        [appleEventManager setEventHandler:self
            andSelector:@selector(handleGetURLEvent:withReplyEvent:)
            forEventClass:kInternetEventClass andEventID:kAEGetURL];*/
        
        
        NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(AppDelegate.handleGetURLEvent(_:withReplyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
        
        Logging.logInfo("Current AppleEvent: \(NSAppleEventManager.shared().currentAppleEvent)")
        Logging.logInfo("Current AppleReplyEvent: \(NSAppleEventManager.shared().currentReplyAppleEvent)")
        //let result = LSSetDefaultHandlerForURLScheme("sdutracker" as CFString, Bundle.main.bundleIdentifier! as CFString)

        //Logging.logInfo("URL RESULT: \(result)")
        Logging.logInfo("log INFO works")
        
        Logging.logInfo("Current AppleEvent 222: \(NSAppleEventManager.shared().currentAppleEvent)")
        Logging.logInfo("Current AppleReplyEvent 222: \(NSAppleEventManager.shared().currentReplyAppleEvent)")
    
        
        //UserHandler.sharedInstance.maybeAskAndSetCorrectUser()
        
        let tracking = Tracking(userHandler: UserHandler.sharedInstance, sendOrSaveHandler: sendOrSaveHandler!)
        tracking.setupTracking()
    }
    
    @objc func handleGetURLEvent(_ event: NSAppleEventDescriptor!, withReplyEvent:NSAppleEventDescriptor!) {
        let url = URL(string: event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))!.stringValue!)!
        Logging.logInfo("THE URL: " + url.absoluteString)
    }
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        self.sendOrSaveHandler?.makeAndSendOrSaveDeviceUsage(eventType: .ended)
        sleep(1)
        return .terminateNow
    }
}


