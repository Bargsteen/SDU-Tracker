//
//  AssemblerProtocol.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 06/11/2018.
//

import Foundation

protocol AssemblerProtocol {
    func resolve() -> LoggerProtocol
    func resolve() -> ActiveWindowHandlerProtocol
    func resolve() -> SettingsProtocol
    func resolve() -> AppTrackerProtocol
    func resolve() -> DeviceTrackerProtocol
    func resolve() -> PersistenceHandlerProtocol
    func resolve() -> RequestHandlerProtocol
    func resolve() -> SendOrSaveHandlerProtocol
    func resolve() -> DateTimeHandlerProtocol
    func resolve() -> UserHandlerProtocol
    func resolve() -> AlertHandlerProtocol
    func resolve() -> ChooseUserWindowProtocol
    func resolve() -> UsageBuilderProtocol
    func resolve() -> SetupHandlerProtocol
}
