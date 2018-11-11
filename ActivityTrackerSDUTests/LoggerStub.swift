//
//  LoggerStub.swift
//  ActivityTrackerSDUTests
//
//  Created by Kasper Dissing Bargsteen on 11/11/2018.
//

import Foundation
@testable import ActivityTrackerSDU

class LoggerStub: LoggerProtocol {
    func logUsage<T>(usage: T, usageLogType: UsageLogType) where T : Usage {
        return
    }
    
    func logInfo(_ msg: String) {
        return
    }
    
    func logDebug(_ msg: String) {
        return
    }
    
    func logWarning(_ msg: String) {
        return
    }
    
    func logError(_ msg: String) {
        return
    }
    
    
}
