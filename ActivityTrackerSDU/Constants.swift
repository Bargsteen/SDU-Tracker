//
//  Constants.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 31/08/2018.
//

import Foundation


extension String {
    static let server = "screens.sdu.dk"
    static let devicePath = "/v1/device_usages"
    static let appPath = "/v1/app_usages"
    static let unnamedUser = "unavngivet-bruger"
    static let unknownApp = "ukendt-applikation"
    
    static let trackingAppData = "Tracker app forbrug"
    static let trackingDeviceData = "Tracker kun tid"
    static let persistenceFileName = "SDU_Activity_Tracker_Data.txt"
}

extension Int {
    static let minWindowArea = 1000
    
}

extension UInt {
    static let frequencyOfFileSavings = 2 * 60 * 1000 // min * sec/min * milliseconds/sec
}
