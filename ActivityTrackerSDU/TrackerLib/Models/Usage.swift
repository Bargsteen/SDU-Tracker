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
}
