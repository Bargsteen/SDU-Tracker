//
//  DeviceUsage.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 04/11/2018.
//

import Foundation

@objcMembers class DeviceUsage: Usage {

    dynamic var eventType = 0
    
    convenience init(participantIdentifier: String, deviceModelName: String, timeStamp: Date, userCount: Int, eventType: EventType) {
        self.init(participantIdentifier, deviceModelName, timeStamp, userCount)
        
        self.eventType = eventType.rawValue
        
        identifier = "[DEVICE] \(self.participantIdentifier)_\(self.timeStamp)_\(self.eventType)"
    }
    
    // Encoding to JSON
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(timeStamp, forKey: .timeStamp)
        try container.encode(eventType, forKey: .eventType)
    }
    
    // Map from "Swifty" property names to actual JSON property names
    private enum CodingKeys: String, CodingKey {
        case eventType = "event_type"
        case timeStamp = "timestamp"
    }
}
