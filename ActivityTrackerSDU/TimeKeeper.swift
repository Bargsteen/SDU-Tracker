//
//  TimeKeeper.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 06/09/2018.
//

import Foundation
import Cocoa

class TimeKeeper {
    private var currentActiveWindow: ActiveWindowTime?
    
    func maybeGetLastActiveWindow() -> ActiveWindowTime? {
        let workspace = NSWorkspace.shared
        let activeApps = workspace.runningApplications
        for app in activeApps {
            if app.isActive {
                let now = Date()
                if let currentActiveWindow = currentActiveWindow {
                    if app.bundleIdentifier != currentActiveWindow.bundleIdentifier { // New window is active
                        // Add the endtime for last current app
                        let lastActiveWindow = ActiveWindowTime(bundleIdentifier: currentActiveWindow.bundleIdentifier, startTime: currentActiveWindow.startTime, endTime: now)
                        
                        // Set new currentApp with starttime
                        self.currentActiveWindow = ActiveWindowTime(bundleIdentifier: app.bundleIdentifier ?? .unknownApp, startTime: now, endTime: nil)
                        
                        return lastActiveWindow
                    }
                } else {
                    // Set new current with starttime
                    self.currentActiveWindow = ActiveWindowTime(bundleIdentifier: app.bundleIdentifier!, startTime: now, endTime: nil)
                }
            }
        }
        return nil
    }
}

struct ActiveWindowTime: Codable {
    let bundleIdentifier: String
    let startTime: Date
    let endTime: Date?
}
