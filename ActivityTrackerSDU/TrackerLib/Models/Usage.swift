//
//  Usage.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 04/11/2018.
//

import Foundation
import RealmSwift

@objcMembers class Usage: Object, Codable {
    dynamic var participantIdentifier = ""
    dynamic var deviceModelName = ""
    dynamic var userCount = 0
    dynamic var identifier = ""
    dynamic var timeStamp = Date.distantPast
    
    convenience init(_ participantIdentifier: String, _ deviceModelName: String, _ timeStamp: Date, _ userCount: Int) {
        // Init Realm specifics from superclass
        self.init()
        
        self.participantIdentifier = participantIdentifier
        self.deviceModelName = deviceModelName
        self.userCount = userCount
        self.timeStamp = timeStamp
    }
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
    
    // Encoding to JSON
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(participantIdentifier, forKey: .participantIdentifier)
        try container.encode(deviceModelName, forKey: .deviceModelName)
        try container.encode(userCount, forKey: .userCount)
    }
    
    private enum CodingKeys: String, CodingKey {
        case participantIdentifier = "participant_identifier"
        case userCount = "user_count"
        case deviceModelName = "device_model_name"
    }
}
