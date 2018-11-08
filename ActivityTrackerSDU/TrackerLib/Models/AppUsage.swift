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
    
    // Encoding to JSON
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(timeStamp, forKey: .timeStamp)
        try container.encode(package, forKey: .package)
        try container.encode(duration, forKey: .duration)
    }
    
    // Map from "Swifty" property names to actual JSON property names
    private enum CodingKeys: String, CodingKey {
        case timeStamp = "date"
        case package
        case duration
    }
}
