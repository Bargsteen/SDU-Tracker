//
//  Container.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 10/11/2018.
//

import Foundation
import Swinject

func getContainer() -> Container {
    let container: Container = {
        let container = Container()
        container.register(ActiveWindowHandlerProtocol.self) { r in ActiveWindowHandler(dateTimeHandler: r.resolve(DateTimeHandlerProtocol.self)!) }
        
        container.register(AlertHandlerProtocol.self) { r in AlertHandler(dateTimeHandler: r.resolve(DateTimeHandlerProtocol.self)!)}.inObjectScope(.container)
        
        container.register(AppTrackerProtocol.self) { r in AppTracker(activeWindowHandler: r.resolve(ActiveWindowHandlerProtocol.self)!, logger: r.resolve(LoggerProtocol.self)!, sendOrSaveHandler: r.resolve(SendOrSaveHandlerProtocol.self)!, persistenceHandler: r.resolve(PersistenceHandlerProtocol.self)!, usageBuilder: r.resolve(UsageBuilderProtocol.self)!)}.inObjectScope(.container)
        
        container.register(UserWindowProtocol.self) { r in UserWindow(settings: r.resolve(SettingsProtocol.self)!)}
        
        container.register(DateTimeHandlerProtocol.self) { _ in DateTimeHandler()}
        
        container.register(DeviceTrackerProtocol.self) { r in DeviceTracker(dateTimeHandler: r.resolve(DateTimeHandlerProtocol.self)!, sendOrSaveHandler: r.resolve(SendOrSaveHandlerProtocol.self)!, settings: r.resolve(SettingsProtocol.self)!, usageBuilder: r.resolve(UsageBuilderProtocol.self)!, userHandler: r.resolve(UserHandlerProtocol.self)!)}.inObjectScope(.container)
        
        container.register(LoggerProtocol.self) { _ in Logger() }.inObjectScope(.container)
        
        container.register(PersistenceHandlerProtocol.self) { r in PersistenceHandler(logger: r.resolve(LoggerProtocol.self)!, settings: r.resolve(SettingsProtocol.self)!)}.inObjectScope(.container)
        
        container.register(RequestHandlerProtocol.self) { r in RequestHandler(logger: r.resolve(LoggerProtocol.self)!)}
        
        container.register(SendOrSaveHandlerProtocol.self) { r in SendOrSaveHandler(logger: r.resolve(LoggerProtocol.self)!, persistenceHandler: r.resolve(PersistenceHandlerProtocol.self)!, requestHandler: r.resolve(RequestHandlerProtocol.self)!, settings: r.resolve(SettingsProtocol.self)!)}.inObjectScope(.container)
        
        container.register(SettingsProtocol.self) { r in Settings(dateTimeHandler: r.resolve(DateTimeHandlerProtocol.self)!)}.inObjectScope(.container)
        
        container.register(SetupHandlerProtocol.self) { r in SetupHandler(alertHandler: r.resolve(AlertHandlerProtocol.self)!, dateTimeHandler: r.resolve(DateTimeHandlerProtocol.self)!, launchAtLoginHandler: r.resolve(LaunchAtLoginHandlerProtocol.self)!, logger: r.resolve(LoggerProtocol.self)!, settings: r.resolve(SettingsProtocol.self)!)}
        
        container.register(UsageBuilderProtocol.self) { r in UsageBuilder(dateTimeHandler: r.resolve(DateTimeHandlerProtocol.self)!, settings: r.resolve(SettingsProtocol.self)!)}
        
        container.register(UserHandlerProtocol.self) { r in UserHandler(alertHandler: r.resolve(AlertHandlerProtocol.self)!, userWindow: r.resolve(UserWindowProtocol.self)!, dateTimeHandler: r.resolve(DateTimeHandlerProtocol.self)!, settings: r.resolve(SettingsProtocol.self)!)}.inObjectScope(.container)
        
        container.register(RunnerProtocol.self) { r in Runner(appTracker: r.resolve(AppTrackerProtocol.self)!, deviceTracker: r.resolve(DeviceTrackerProtocol.self)!, alertHandler: r.resolve(AlertHandlerProtocol.self)!, dateTimeHandler: r.resolve(DateTimeHandlerProtocol.self)!, launchAtLoginHandler: r.resolve(LaunchAtLoginHandlerProtocol.self)!, logger: r.resolve(LoggerProtocol.self)!, userHandler: r.resolve(UserHandlerProtocol.self)!, usageBuilder: r.resolve(UsageBuilderProtocol.self)!, sendOrSaveHandler: r.resolve(SendOrSaveHandlerProtocol.self)!, settings: r.resolve(SettingsProtocol.self)!)}
        
        container.register(LaunchAtLoginHandlerProtocol.self) { _ in LaunchAtLoginHandler() }
        
        return container
    }()
    
    return container
}


