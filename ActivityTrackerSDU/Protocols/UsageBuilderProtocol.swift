//
//  UsageBuilderProtocol.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 06/11/2018.
//

import Foundation

protocol UsageBuilderProtocol {
    func makeDeviceUsage(eventType: EventType) -> DeviceUsage
    func makeDeviceUsage(eventType: EventType, user: String) -> DeviceUsage
    func makeAppUsage(activeWindow: ActiveWindow) -> AppUsage
}
