//
//  Runner.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 10/11/2018.
//

import Foundation

class Runner: RunnerProtocol {
    
    private let appTracker: AppTrackerProtocol
    private let deviceTracker: DeviceTrackerProtocol
    
    private let dateTimeHandler: DateTimeHandlerProtocol
    private var launchAtLoginHandler: LaunchAtLoginHandlerProtocol
    private let logger: LoggerProtocol
    private let userHandler: UserHandlerProtocol
    private let usageBuilder: UsageBuilderProtocol
    private let sendOrSaveHandler: SendOrSaveHandlerProtocol
    private let settings: SettingsProtocol
    
    init(assembler: AssemblerProtocol) {
        self.appTracker = assembler.resolve()
        self.deviceTracker = assembler.resolve()
        self.dateTimeHandler = assembler.resolve()
        self.launchAtLoginHandler = assembler.resolve()
        self.logger = assembler.resolve()
        self.userHandler = assembler.resolve()
        self.usageBuilder = assembler.resolve()
        self.sendOrSaveHandler = assembler.resolve()
        self.settings = assembler.resolve()

    }
    
    func run(){
        if(settings.appHasBeenSetup){
            let today = dateTimeHandler.now
            
            if(settings.stopTrackingDate >= today) {
                
                // Correct User
                userHandler.checkIfUserHasChanged()
                
                // Tracking
                if(settings.trackingType == .AppAndDevice) {
                    appTracker.startTracking()
                    deviceTracker.startTracking()
                } else {
                    deviceTracker.startTracking()
                }
                
            } else {
                // TODO: Check if there are saved entries in db.
                // TODO: Display alert saying "Thank you. We will stop tracking now."
                logger.logInfo("Tracking date has been reached. Disabling Launch at Login and terminating app.")
                launchAtLoginHandler.isEnabled = false
                exit(0)
            }
        } else {
            logger.logInfo("App has not been setup.")
        }
    }
    
    func terminate() {
        if(settings.appHasBeenSetup){
            let deviceUsage = usageBuilder.makeDeviceUsage(eventType: .ended)
            sendOrSaveHandler.sendOrSaveUsage(usage: deviceUsage, fromPersistence: false)
        }
    }
}
