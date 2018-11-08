//
//  Assembler.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 06/11/2018.
//

import Foundation

class Assembler: AssemblerProtocol {
    private let logger: LoggerProtocol
    
    init() {
        self.logger = Logger()
    }
    
    func resolve() -> LoggerProtocol {
        return self.logger
    }
    
    func resolve() -> ActiveWindowHandlerProtocol {
        return ActiveWindowHandler(assembler: self)
    }
    
    func resolve() -> SettingsProtocol {
        return Settings(assembler: self)
    }
    
    func resolve() -> AppTrackerProtocol {
        return AppTracker(assembler: self)
    }
    
    func resolve() -> DeviceTrackerProtocol {
        return DeviceTracker(assembler: self)
    }
    
    func resolve() -> PersistenceHandlerProtocol {
        return PersistenceHandler(assembler: self)
    }
    
    func resolve() -> RequestHandlerProtocol {
        return RequestHandler(assembler: self)
    }
    
    func resolve() -> SendOrSaveHandlerProtocol {
        return SendOrSaveHandler(assembler: self)
    }
    
    func resolve() -> DateTimeHandlerProtocol {
        return DateTimeHandler()
    }
    
    func resolve() -> UserHandlerProtocol {
        return UserHandler(assembler: self)
    }
    
    func resolve() -> AlertHandlerProtocol {
        return AlertHandler(assembler: self)
    }
    
    func resolve() -> ChooseUserWindowProtocol {
        return ChooseUserWindow(assembler: self)
    }
    
    func resolve() -> UsageBuilderProtocol {
        return UsageBuilder(assembler: self)
    }
    
    func resolve() -> SetupHandlerProtocol {
        return SetupHandler(assembler: self)
    }
}
