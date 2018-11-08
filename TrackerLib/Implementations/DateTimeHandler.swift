//
//  DateTimeHandler.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 06/11/2018.
//

import Foundation

class DateTimeHandler: DateTimeHandlerProtocol {
    var now: Date {
        get {
            return Date()
        }
    }
    
}
