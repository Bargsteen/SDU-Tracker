//
//  Logging.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 22/09/2018.
//

import Foundation
import CocoaLumberjack
import CocoaLumberjackSwift

public class Logging {
    
    static func setupLogger(){
        //DDLog.add(DDTTYLogger.sharedInstance) // TTY = Xcode console. The xcode console also print ASL messages.
        DDLog.add(DDASLLogger.sharedInstance) // ASL = Apple System Logs
        
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = TimeInterval(60*60*24*7)  // 7 days
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }
    
    // Simple redirect functions. Makes it easy to switch to another logger.
    static func logError(_ msg: String){
        DDLogError("[ERROR] \(msg)")
    }
    static func logWarning(_ msg: String){
        DDLogWarn("[WARNING] \(msg)")
    }
    static func logInfo(_ msg: String){
        DDLogInfo("[INFO] \(msg)")
    }
    static func logDebug(_ msg: String){
        DDLogDebug("[DEBUG] \(msg)")
    }
    
    static func logUsage<T:Usage>(usage: T, usageLogType: UsageLogType) {
        var logMsg = "\(usageLogType.rawValue)"
        
        if let deviceUsage = usage as? DeviceUsage {
            logMsg += "[DEVICE] \(eventTypeToString(deviceUsage.eventType))"
        } else if let appUsage = usage as? AppUsage {
            logMsg += "[APP] \(appUsage.package) - \(appUsage.duration) ms"
        }
        
        logInfo(logMsg)
    }
}

enum UsageLogType: String {
    case sentDirectly = "Sent directly: "
    case sentFromPersistence = "Sent from storage: "
    case saved = "Saved: "
}
