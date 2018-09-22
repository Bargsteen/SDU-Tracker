//
//  AppDelegate.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 17/08/2018.
//

import Cocoa
import ServiceManagement

extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}


@NSApplicationMain
class AppDelegate: NSObject {}


extension AppDelegate: NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let launcherAppId = "dk.sdu.health.ActivityTrackerLauncher"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == launcherAppId }.isEmpty
        
        SMLoginItemSetEnabled(launcherAppId as CFString, true)
        
        if isRunning {
            DistributedNotificationCenter.default().post(name: .killLauncher,
                                                         object: Bundle.main.bundleIdentifier!)
        }
    }
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        if(!UserDefaultsHelper.getUseAppTracking()) {
            sendDeviceUsage(eventType: .ended)
            sleep(1) // Wait a second to ensure the device usage is sent. TODO: Make a cleaner handling.
        }
        
        return .terminateNow
        
    }
}


