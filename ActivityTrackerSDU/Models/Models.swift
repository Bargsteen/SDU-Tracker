//
//  Models.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 16/09/2018.
//

import Foundation


public protocol Identifiable {
    func getIdentifier() -> String
}

public typealias Usage = Codable & Identifiable & Persistable

struct AppUsage: Codable, Identifiable {
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
    
    func getIdentifier() -> String {
        return "[APP] \(self.participantIdentifier)_\(self.timeStamp)_\(self.package)"
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

struct DeviceUsage: Codable, Identifiable {
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
    
    func getIdentifier() -> String {
        return "[DEVICE] \(self.participantIdentifier)_\(self.timeStamp)_\(self.eventType)"
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
    case started = 1, ended = 0
}

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

enum UsageType: String {
    case app = "App "
    case device = "Tid "
}

protocol ToString {
    func toString() -> String
}


