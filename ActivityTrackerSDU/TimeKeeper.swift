//
//  TimeKeeper.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 06/09/2018.
//

import Foundation

class TimeKeeper {
    private var timeTable : [WindowInfo: Date]
    
    init() {
        timeTable = [:]
    }
    
    func noteOpenWindows(windows: [WindowInfo]) {
        
        var windowsStillAlive : [WindowInfo : Bool] = Dictionary(uniqueKeysWithValues: timeTable.map { ($0.key, false) })
        
        for window in windows {
            // Check which tracked windows are still alive. And add new ones to the list.
            if windowsStillAlive.keys.contains(window) {
                windowsStillAlive[window] = true
            } else { // New window
                timeTable[window] = Date()
            }
        }
        
        // Collect all recently closed windows
        let recentlyClosedWindows = windowsStillAlive.filter({ id, alive in !alive })
        
        recentlyClosedWindows.forEach { closedWindow in
            timeTable.removeValue(forKey: closedWindow.key)
            print("Recently Closed: \(closedWindow.key)")
        }
    }
}
