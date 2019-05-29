//
//  Logger.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 22/09/2018.
//

import Foundation
import CocoaLumberjack
import CocoaLumberjackSwift

class Logger : LoggerProtocol {
    init() {
        DDLog.add(DDOSLogger.sharedInstance) // ASL = Apple System Logs
        
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = TimeInterval(60*60*24*7)  // 7 days
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }
    
    // Simple redirect functions. Makes it easy to switch to another logger.
    func logInfo(_ msg: String){
        DDLogInfo("[INFO] \(msg)")
    }
    func logDebug(_ msg: String){
        DDLogDebug("[DEBUG] \(msg)")
    }
    func logWarning(_ msg: String){
        DDLogWarn("[WARNING] \(msg)")
    }
    func logError(_ msg: String){
        DDLogError("[ERROR] \(msg)")
    }
  
    
    func logUsage<T:Usage>(usage: T, usageLogType: UsageLogType) {
        var logMsg = "\(usageLogType.rawValue)"
        
        if let deviceUsage = usage as? DeviceUsage {
            logMsg += "[DEVICE] - \(deviceUsage.participantIdentifier) - \(eventTypeToString(deviceUsage.eventType))"
        } else if let appUsage = usage as? AppUsage {
            logMsg += "[APP] - \(appUsage.participantIdentifier) - \(appUsage.package) - \(appUsage.duration) ms"
        }
        
        logInfo(logMsg)
    }
    
    // Remember to change the values here, if EventType is changed.
    private func eventTypeToString(_ eventType: Int) -> String {
        return eventType == 1 ? "Started" : "Ended"
    }
}


