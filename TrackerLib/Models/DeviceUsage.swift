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
    
    // Map from "Swifty" property names to actual JSON property names
    enum CodingKeys: String, CodingKey {
        case participantIdentifier = "participant_identifier"
        case eventType = "event_type"
        case timeStamp = "timestamp"
        case userCount = "user_count"
        case deviceModelName = "device_model_name"
    }
}
