//
//  LaunchAtLogin.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 10/11/2018.
//

import Foundation
import LaunchAtLogin

class LaunchAtLoginHandler: LaunchAtLoginHandlerProtocol {
    var launchAtStartupIsEnabled: Bool {
        get {
            return LaunchAtLogin.isEnabled
        }
        set {
            LaunchAtLogin.isEnabled = newValue
        }
    }
}
