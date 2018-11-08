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
    
    private let appTracker: AppTrackerProtocol
    private let deviceTracker: DeviceTrackerProtocol
    
    private let dateTimeHandler: DateTimeHandlerProtocol
    private let logger: LoggerProtocol
    private let userHandler: UserHandlerProtocol
    private let usageBuilder: UsageBuilderProtocol
    private let sendOrSaveHandler: SendOrSaveHandlerProtocol
    private let settings: SettingsProtocol
    private let setupHandler: SetupHandlerProtocol
    
    
    override init(){
        let assembler: AssemblerProtocol = Assembler()
        
        self.appTracker = assembler.resolve()
        self.deviceTracker = assembler.resolve()
        self.dateTimeHandler = assembler.resolve()
        self.logger = assembler.resolve()
        self.userHandler = assembler.resolve()
        self.usageBuilder = assembler.resolve()
        self.sendOrSaveHandler = assembler.resolve()
        self.settings = assembler.resolve()
        self.setupHandler = assembler.resolve()
        
        super.init()
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        // Subscribe to open by url event
        NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(AppDelegate.handleGetURLEvent(_:withReplyEvent:)),
                                                     forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
        
        if(settings.appHasBeenSetup){
            begin()
        }else {
            logger.logInfo("App has not been setup.")
        }
    }
    
    @objc func handleGetURLEvent(_ event: NSAppleEventDescriptor!, withReplyEvent:NSAppleEventDescriptor!) {
        
        let url = URL(string: event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))!.stringValue!)!
        
        let setupSucceeded = setupHandler.parseUrlAndSetupApp(url)
        if(setupSucceeded){
            setupHandler.showSetupResultAlert(succeeded: setupSucceeded)
            begin()
        } else {
            setupHandler.showSetupResultAlert(succeeded: setupSucceeded)
            exit(1)
        }
    }
    
    
    func begin() {
        let today = dateTimeHandler.now
        
        if(settings.stopTrackingDate >= today) {
            
            // Correct User
            userHandler.checkIfUserHasChanged()
            
            // Tracking
            if(settings.trackingType == .AppAndDevice) {
                appTracker.startTracking()
                deviceTracker.startTracking()
            } else {
                deviceTracker.startTracking()
            }

        } else {
            // TODO: Check if there are saved entries in db.
            // TODO: Display alert saying "Thank you. We will stop tracking now."
            logger.logInfo("Tracking date has been reached. Disabling Launch at Login and terminating app.")
            LaunchAtLogin.isEnabled = false
            exit(0)
        }
    }

    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        
        if(settings.appHasBeenSetup){
            let deviceUsage = usageBuilder.makeDeviceUsage(eventType: .ended)
            sendOrSaveHandler.sendOrSaveUsage(usage: deviceUsage, fromPersistence: false)
        }
        
        sleep(1)
        return .terminateNow
    }
}


