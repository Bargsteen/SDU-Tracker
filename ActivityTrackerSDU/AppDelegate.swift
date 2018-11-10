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
    
    private let runner: RunnerProtocol
    private let setupHandler: SetupHandlerProtocol
    
    override init(){
        let assembler: AssemblerProtocol = Assembler()
        
        self.runner = assembler.resolve()
        self.setupHandler = assembler.resolve()
        
        super.init()
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        // Subscribe to open by url event
        NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(AppDelegate.handleGetURLEvent(_:withReplyEvent:)),
                                                     forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
        
        // Return if this is a unit test
        if let _ = NSClassFromString("XCTest") {
            return
        }
        
        runner.run()
    }
    
    @objc func handleGetURLEvent(_ event: NSAppleEventDescriptor!, withReplyEvent:NSAppleEventDescriptor!) {
        
        let url = URL(string: event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))!.stringValue!)!
        
        let setupSucceeded = setupHandler.parseUrlAndSetupApp(url)
        if(setupSucceeded){
            setupHandler.showSetupResultAlert(succeeded: setupSucceeded)
            runner.run()
        } else {
            setupHandler.showSetupResultAlert(succeeded: setupSucceeded)
            exit(1)
        }
    }
    
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        
        runner.terminate()
        
        sleep(1)
        return .terminateNow
    }
}


