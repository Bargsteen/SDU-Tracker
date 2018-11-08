//
//  LoggerProtocol.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 04/11/2018.
//

import Foundation

protocol LoggerProtocol {
    func logUsage<T:Usage>(usage: T, usageLogType: UsageLogType)
    
    func logInfo(_ msg: String)
    func logDebug(_ msg: String)
    func logWarning(_ msg: String)
    func logError(_ msg: String)
}
