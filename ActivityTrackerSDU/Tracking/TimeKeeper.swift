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
        let frontMostApp = workspace.frontmostApplication
        
        if let frontMostApp = frontMostApp {
            let now = Date()
            if let currentActiveWindow = currentActiveWindow {
                if frontMostApp.bundleIdentifier != currentActiveWindow.bundleIdentifier { // New window is active
                    // Add the endtime for last current app
                    let lastActiveWindow = ActiveWindowTime(bundleIdentifier: currentActiveWindow.bundleIdentifier, startTime: currentActiveWindow.startTime, endTime: now)
                    
                    // Set new currentApp with starttime
                    self.currentActiveWindow = ActiveWindowTime(bundleIdentifier: frontMostApp.bundleIdentifier ?? .unknownApp, startTime: now, endTime: nil)
                    //Logging.logInfo(app.)
                    
                    // When the mac sleeps, the last active app becomes com.apple.loginwindow. We do not want to track that.
                    if(lastActiveWindow.bundleIdentifier == "com.apple.loginwindow"){
                        return nil
                    }
                    
                    return lastActiveWindow
                }
            } else {
                // Set new current with starttime
                self.currentActiveWindow = ActiveWindowTime(bundleIdentifier: frontMostApp.bundleIdentifier!, startTime: now, endTime: nil)
            }
        }
        return nil
    }
    
    // This function is used for terminating and sending last AppUsage when the Mac goes to sleep
    func maybeTerminateAndGetCurrentActiveWindow() -> ActiveWindowTime? {
        if let currentActiveWindow = currentActiveWindow {
            let now = Date()
            return ActiveWindowTime(bundleIdentifier: currentActiveWindow.bundleIdentifier, startTime: currentActiveWindow.startTime, endTime: now)
        }
        
        Logging.logError("Tried to terminate and get current ActiveWindowTime, but currentActiveWindow was nil.")
        return nil
    }
}

struct ActiveWindowTime: Codable {
    let bundleIdentifier: String
    let startTime: Date
    let endTime: Date?
}
