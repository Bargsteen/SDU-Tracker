//
//  AppDelegate.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 17/08/2018.
//

import Cocoa
import ServiceManagement
import LaunchAtLogin

@NSApplicationMain
class AppDelegate: NSObject {}


extension AppDelegate: NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        LaunchAtLogin.isEnabled = true
        Logging.setupLogger()
    }
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        sendDeviceUsage(eventType: .ended)
        sleep(1) // Wait a second to ensure the device usage is sent. TODO: Make a cleaner handling.
        return .terminateNow
    }
}


