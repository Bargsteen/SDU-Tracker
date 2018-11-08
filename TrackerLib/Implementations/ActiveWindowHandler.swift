//
//  ActiveWindowHandler.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 06/09/2018.
//

import Foundation
import Cocoa

class ActiveWindowHandler: ActiveWindowHandlerProtocol {
    private var currentActiveWindow: ActiveWindow?
    private let dateTimeHandler: DateTimeHandlerProtocol
    
    init(assembler: AssemblerProtocol) {
        self.dateTimeHandler = assembler.resolve()
    }
    
    
    func maybeGetLastActiveWindow() -> ActiveWindow? {
        
        let workspace = NSWorkspace.shared
        let frontMostApp = workspace.frontmostApplication
        
        if let frontMostApp = frontMostApp {
            let now = dateTimeHandler.now
            if let currentActiveWindow = currentActiveWindow {
                if frontMostApp.bundleIdentifier != currentActiveWindow.bundleIdentifier { // New window is active
                    // Add the endtime for last current app
                    let lastActiveWindow = ActiveWindow(bundleIdentifier: currentActiveWindow.bundleIdentifier, startTime: currentActiveWindow.startTime, endTime: now)
                    
                    // Set new currentApp with starttime
                    self.currentActiveWindow = ActiveWindow(bundleIdentifier: frontMostApp.bundleIdentifier ?? .unknownApp, startTime: now, endTime: nil)
                    //Logging.logInfo(app.)
                    
                    // When the mac sleeps, the last active app becomes com.apple.loginwindow. We do not want to track that.
                    if(lastActiveWindow.bundleIdentifier == "com.apple.loginwindow"){
                        return nil
                    }
                    
                    return lastActiveWindow
                }
            } else {
                // Set new current with starttime
                self.currentActiveWindow = ActiveWindow(bundleIdentifier: frontMostApp.bundleIdentifier!, startTime: now, endTime: nil)
            }
        }
        return nil
    }
}
