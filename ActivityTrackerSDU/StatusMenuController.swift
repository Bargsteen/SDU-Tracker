//
//  StatusMenuController.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 17/08/2018.
//

import Cocoa
import RealmSwift
import Realm
import Foundation
import SwiftLog


class StatusMenuController: NSObject, ChooseUserWindowDelegate{
    
    @IBOutlet weak var statusMenu: NSMenu!
    
    let reachability = Reachability()!
   
    var chooseUserWindow: ChooseUserWindow!
    var credentialsWindow: CredentialsWindow!
    
    var timeKeeper : TimeKeeper!
    
    @IBOutlet weak var action: NSMenuItem!
    @IBOutlet weak var notificationSetting: NSMenuItem!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    override func awakeFromNib() {
        let icon = #imageLiteral(resourceName: "statusIcon")
        icon.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
    
        // Window initialization
        chooseUserWindow = ChooseUserWindow()
        chooseUserWindow.delegate = self
        credentialsWindow = CredentialsWindow()
        
        action.title = UserDefaultsHelper.getUseAppTracking() ? .trackingAppData : .trackingDeviceData
        notificationSetting.title = UserDefaultsHelper.getShowNotificationsSetting() ? .notificationsEnabled : .notificationsDisabled
        
        // Initialization
        timeKeeper = TimeKeeper()
    
        setAndMaybeAskForCorrectUser()
        
        ensureCredentialsAreSet()
        
        // Set Defaults
        UserDefaultsHelper.setDeviceModelName(Sysctl.model)
        //UserDefaultsHelper.setShowNotificationsSetting(false)
        
        if let credentials = loadCredentialsFromKeychain() {
            
            setUpDeviceUsageTracking()
            
            setupAppUsageTracking(credentials: credentials)
        }
    }
    

    
    func maybeGetLastAppUsage() -> AppUsage? {
        let activeWindow = self.timeKeeper.maybeGetLastActiveWindow()
        if let activeWindow = activeWindow {
            let participantIdentifier = UserDefaultsHelper.getParticipantIdentifier()
            let deviceModelName = UserDefaultsHelper.getDeviceModelName()
            let duration = activeWindow.endTime?.timeIntervalSince(activeWindow.startTime) ?? 0
            return AppUsage(participantIdentifier: participantIdentifier, timeStamp: Date(), userCount: UserDefaultsHelper.getUserCount(), deviceModelName: deviceModelName, package: activeWindow.bundleIdentifier, duration: duration.toMilliseconds())
        }
        return nil
    }
    
    func userHasChanged(_ nameOfUser : String) {
        print("Current user changed to: \(nameOfUser)")
    }
    
    func showChangeUserAlert(_ currentUser : String) -> Bool {
        let alert = NSAlert()
        alert.messageText = "Er du \(currentUser)?"
        alert.informativeText = "Hvis ikke, så skift nuværende bruger."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Ja, det er mig")
        alert.addButton(withTitle: "Nej, skift bruger")
        return alert.runModal() == .alertFirstButtonReturn
    }
    
    // Used only for testing
    @IBAction func deleteCredentialsClicked(_ sender: NSMenuItem) {
        do {
            try deleteCredentialsFromKeychain()
        } catch {
        }
    }
    
    @IBAction func showDBContentClicked(_ sender: NSMenuItem) {
        printSavedAppUsages()
    }
    @IBAction func notificationSettingClicked(_ sender: NSMenuItem) {
        let showNotifications = UserDefaultsHelper.getShowNotificationsSetting()
        if(showNotifications){
            notificationSetting.title = .notificationsDisabled
            
        } else {
            notificationSetting.title = .notificationsEnabled
        }
        UserDefaultsHelper.setShowNotificationsSetting(!showNotifications)
    }
    
    func printSavedAppUsages() {
        let appUsages = Persistence.fetchAllAppUsages().sorted {(first, second) in first.timeStamp <= second.timeStamp }
        appUsages.forEach {usage in print("\(usage.timeStamp) -- \(usage.package)") }
    }
    
    @IBAction func chooseUserClicked(_ sender: NSMenuItem) {
        chooseUserWindow.showWindow(nil)
    }
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func toggleAppDeviceTrackingClicked(_ sender: NSMenuItem) {
        let useAppTracking = UserDefaultsHelper.getUseAppTracking()
        if(useAppTracking){
            action.title = .trackingDeviceData
            sendDeviceUsage(eventType: .started)
        } else {
            action.title = .trackingAppData
            sendDeviceUsage(eventType: .ended)
        }
        UserDefaultsHelper.setUseAppTracking(!useAppTracking)
    }
    
    func ensureCredentialsAreSet() {
        let credentials = loadCredentialsFromKeychain()
        if credentials == nil {
            credentialsWindow.showWindow(nil)
        }
    }
    
    func setUpDeviceUsageTracking() {
        let useAppTracking = UserDefaultsHelper.getUseAppTracking()
        if !useAppTracking {
            sendDeviceUsage(eventType: .started)
        }
        
        let notificationCenter = NSWorkspace.shared.notificationCenter
        
        // Handle waking aka Session start
        notificationCenter.addObserver(forName: NSWorkspace.screensDidWakeNotification, object: nil, queue: nil, using: {(n:Notification) in
            
            self.setAndMaybeAskForCorrectUser()
            
            if(!UserDefaultsHelper.getUseAppTracking()) {
                sendDeviceUsage(eventType: EventType.started)
            }
        })
        
        // Handle sleeping aka Session end
        notificationCenter.addObserver(forName: NSWorkspace.screensDidSleepNotification, object: nil, queue: nil, using: {(n:Notification) in
            if (!UserDefaultsHelper.getUseAppTracking()) {
                sendDeviceUsage(eventType: EventType.ended)
            }
        })
    }
    
    func setAndMaybeAskForCorrectUser(){
        // Get current user
        let currentUser = UserDefaultsHelper.getCurrentUser()
        
        if(UserDefaultsHelper.getUserCount() > 1) {
            // Handle if it is the correct user
            let changeOfUserIsNeeded = !showChangeUserAlert(currentUser)
            
            if(changeOfUserIsNeeded){
                chooseUserWindow.showWindow(nil)
            }
        }        
    }
    
    func setupAppUsageTracking(credentials: Credentials) {
        // Reachability
        
        reachability.whenReachable = { reachability in
            DispatchQueue.global(qos: .background).async {
                
                
                while(true) {
                    if(self.reachability.connection == Reachability.Connection.none) {
                        break
                    }
                    
                    // TODO: Only check DB if flag has been set to do so
                    //self.maybeSendOldestSavedAppUsage()
                    //self.maybeSendOldDeviceUsages()
                    
                    
                    if UserDefaultsHelper.getUseAppTracking() {
                        if let lastAppUsage = self.maybeGetLastAppUsage() {
                            let usageDescription = "\(lastAppUsage.package) i \(lastAppUsage.duration) ms"
                            sendUsage(usage: lastAppUsage, usageType: .app, credentials: credentials
                                , onSuccess: {
                                    maybeShowSentSavedNotification(shouldShow: UserDefaultsHelper.getShowNotificationsSetting(), usageType: .app, notificationType: .sent, usageDescription: usageDescription)
                                    }
                                , onError: { _ in
                                    maybeShowSentSavedNotification(shouldShow: UserDefaultsHelper.getShowNotificationsSetting(), usageType: .app, notificationType: .saved, usageDescription: usageDescription)
                                    Persistence.save(lastAppUsage) }
                            )
                        }
                    }
                    sleep(1)
                }
            }
        }
        
        reachability.whenUnreachable = { _ in
            DispatchQueue.global(qos: .background).async {
                while(true) {
                    if(self.reachability.connection != Reachability.Connection.none) {
                        break
                    }
                    
                    if UserDefaultsHelper.getUseAppTracking() {
                        if let lastAppUsage = self.maybeGetLastAppUsage() {
                            let usageDescription = "\(lastAppUsage.package) i \(lastAppUsage.duration) ms"
                            maybeShowSentSavedNotification(shouldShow: UserDefaultsHelper.getShowNotificationsSetting(), usageType: .app, notificationType: .saved, usageDescription: usageDescription)
                            Persistence.save(lastAppUsage)
                        }
                    }
                    // Wait one second before trying to get the app usage.
                    // Could perhaps be handled by an event listener.
                    sleep(1)
                }
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            Logging.logError("Unable to start reachability notifier: \(error)")
            print("Unable to start reachability notifier")
        }
    }
    

}

