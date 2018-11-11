//
//  AppUsage.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 04/11/2018.
//

import Foundation

class AppUsage: Usage {
    
    var package: String = ""
    var duration: Int = 0
    
    convenience init(participantIdentifier: String, deviceModelName: String, timeStamp: Date, userCount: Int, package: String, duration: Int) {
        self.init(participantIdentifier, deviceModelName, timeStamp, userCount)
        
        self.package = package
        self.duration = duration
    }
    
    // Used for database fetches
    convenience init(participantIdentifier: String, deviceModelName: String, timeStamp: Date, userCount: Int, package: String, duration: Int, id: Int64) {
        self.init(participantIdentifier: participantIdentifier, deviceModelName: deviceModelName, timeStamp: timeStamp, userCount: userCount, package: package, duration: duration)
        
        self.id = id
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
