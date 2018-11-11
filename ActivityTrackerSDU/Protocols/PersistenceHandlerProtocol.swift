//
//  PersistenceHandlerProtocol.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 04/11/2018.
//

import Foundation

protocol PersistenceHandlerProtocol {
    func save<T:Usage>(_ usage: T)
    func delete<T: Usage>(_ usage: T)
    func fetchDeviceUsages(upTo: Int) -> [DeviceUsage]
    func fetchAppUsages(upTo: Int) -> [AppUsage]
}
