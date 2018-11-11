//
//  Usage.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 04/11/2018.
//

import Foundation

class Usage: Codable {
    var participantIdentifier: String = ""
    var deviceModelName: String = ""
    var userCount: Int = 0
    var id: Int64?
    var timeStamp: Date = Date.distantPast
    
    init(_ participantIdentifier: String, _ deviceModelName: String, _ timeStamp: Date, _ userCount: Int) {
        self.participantIdentifier = participantIdentifier
        self.deviceModelName = deviceModelName
        self.userCount = userCount
        self.timeStamp = timeStamp
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
