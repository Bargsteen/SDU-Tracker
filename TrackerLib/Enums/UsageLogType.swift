//
//  UsageLogType.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 04/11/2018.
//

import Foundation

enum UsageLogType: String {
    case sentDirectly = "Sent directly: "
    case sentFromPersistence = "Sent from storage: "
    case saved = "Saved: "
}
