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
        DDLog.add(DDTTYLogger.sharedInstance) // TTY = Xcode console
        DDLog.add(DDASLLogger.sharedInstance) // ASL = Apple System Logs
        
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = TimeInterval(60*60*24*7)  // 7 days
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }
    
    static func testLogger() {
        logError("Error Test")
        logWarning("Warning Test")
        logInfo("Info Test")
        logDebug("Debug Test")
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
}
