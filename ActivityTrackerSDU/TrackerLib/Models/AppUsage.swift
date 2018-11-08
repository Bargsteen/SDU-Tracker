//
//  AppUsage.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 04/11/2018.
//

import Foundation

@objcMembers class AppUsage: Usage {
    
    dynamic var package = ""
    dynamic var duration = 0
    
    convenience init(participantIdentifier: String, deviceModelName: String, timeStamp: Date, userCount: Int, package: String, duration: Int) {
        self.init(participantIdentifier, deviceModelName, timeStamp, userCount)
        
        self.package = package
        self.duration = duration
        
        identifier = "[APP] \(self.participantIdentifier)_\(self.timeStamp)_\(self.package)"
    }
    
    // Map from "Swifty" property names to actual JSON property names
    enum CodingKeys: String, CodingKey {
        case participantIdentifier = "participant_identifier"
        case timeStamp = "date"
        case userCount = "user_count"
        case deviceModelName = "device_model_name"
        case package
        case duration
    }
}
