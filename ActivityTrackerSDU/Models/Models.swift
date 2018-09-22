//
//  Models.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 16/09/2018.
//

import Foundation


struct AppUsage: Codable {
    let participantIdentifier : String
    let timeStamp: String
    let userCount: Int
    let deviceModelName: String
    
    let package: String
    let duration: UInt
    
    
    init(participantIdentifier: String, timeStamp: Date, userCount: Int, deviceModelName: String, package: String, duration: UInt) {
        self.participantIdentifier = participantIdentifier
        self.timeStamp = timeStamp.description
        self.userCount = userCount
        self.deviceModelName = deviceModelName
        self.package = package
        self.duration = duration
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

struct DeviceUsage: Codable {
    let participantIdentifier : String
    let eventType: Int
    let timeStamp: String
    let userCount: Int
    let deviceModelName: String
    
    init(participantIdentifier: String, eventType: EventType, timeStamp: Date, userCount: Int, deviceModelName: String) {
        self.participantIdentifier = participantIdentifier
        self.eventType = eventType.rawValue
        self.timeStamp = timeStamp.description
        self.userCount = userCount
        self.deviceModelName = deviceModelName
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

enum EventType: Int {
    case started = 0, ended = 1
}

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

enum UsageType: String {
    case app = "App "
    case device = "Tid "
}
