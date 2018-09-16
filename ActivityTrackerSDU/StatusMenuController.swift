//
//  StatusMenuController.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 17/08/2018.
//

import Cocoa
import Foundation

class StatusMenuController: NSObject, ChooseUserWindowDelegate {
    
    @IBOutlet weak var statusMenu: NSMenu!
    
    let reachability = Reachability()!
    
    var useAppData = false
    
    let deviceModelName = Sysctl.model
    var currentUser : String = .unnamedUser
    var credentials : Credentials!
    
    var chooseUserWindow: ChooseUserWindow!
    var credentialsWindow: CredentialsWindow!
    
    var timeKeeper : TimeKeeper!
    var dataPersistence : DataPersistence!
    
    @IBOutlet weak var action: NSMenuItem!
    
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
        
        // Initialization
        timeKeeper = TimeKeeper()

    
        // Observe changes such as screen awake / asleep
        setUpDeviceUsageTracking()
        
        setAndMaybeAskForCorrectUser()
        
        ensureCredentialsAreSet()
        self.credentials = loadCredentialsFromKeychain()
        
        dataPersistence = DataPersistence(directoryToUse: Storage.Directory.documents)
        
        setupReachability()
        
        if !self.useAppData {
            self.sendDeviceUsage(eventType: .started)
        }
    }
    
    func maybeGetLastAppUsage() -> AppUsage? {
        let activeWindow = self.timeKeeper.maybeGetLastActiveWindow()
        if let activeWindow = activeWindow {
            let duration = activeWindow.endTime?.timeIntervalSince(activeWindow.startTime) ?? 0
            return AppUsage(participantIdentifier: self.currentUser, timeStamp: Date(), userCount: self.getUserCount(), deviceModelName: self.deviceModelName, package: activeWindow.bundleIdentifier, duration: duration.toMilliseconds())
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
    
    @IBAction func deleteCredentialsClicked(_ sender: NSMenuItem) {
        do {
            try deleteCredentialsFromKeychain()
        } catch {
            print("Could not delete credentials..")
        }
    }
    
    @IBAction func chooseUserClicked(_ sender: NSMenuItem) {
        chooseUserWindow.showWindow(nil)
    }
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func toggleAppDeviceTrackingClicked(_ sender: NSMenuItem) {
        if(useAppData){
            action.title = .trackingDeviceData
            useAppData = false
            self.sendDeviceUsage(eventType: .started)
        } else {
            action.title = .trackingAppData
            useAppData = true
            self.sendDeviceUsage(eventType: .ended)
        }
    }
    
    func getCurrentUser() -> String {
        return UserDefaults.standard.string(forKey: "currentUser") ?? .unnamedUser
    }
    
    func ensureCredentialsAreSet() {
        let credentials = loadCredentialsFromKeychain()
        if credentials == nil {
            credentialsWindow.showWindow(nil)
        }
    }
    
    func setUpDeviceUsageTracking() {
        
        let notificationCenter = NSWorkspace.shared.notificationCenter
        
        // Handle waking aka Session start
        notificationCenter.addObserver(forName: NSWorkspace.screensDidWakeNotification, object: nil, queue: nil, using: {(n:Notification) in
            if(!self.useAppData) {
                self.sendDeviceUsage(eventType: EventType.started)
            }
        })
        
        // Handle sleeping aka Session end
        notificationCenter.addObserver(forName: NSWorkspace.screensDidSleepNotification, object: nil, queue: nil, using: {(n:Notification) in
            if (!self.useAppData) {
                self.sendDeviceUsage(eventType: EventType.ended)
            }
        })
    }
    
    func makeDeviceUsage(eventType: EventType) -> DeviceUsage {
        return DeviceUsage(participantIdentifier: self.currentUser, eventType: eventType, timeStamp: Date(), userCount: getUserCount(), deviceModelName: self.deviceModelName)
    }
    
    func getUserCount() -> Int {
        let userList = UserDefaults.standard.stringArray(forKey: "users")
        return userList?.count ?? 1
    }
    
    func sendDeviceUsage(eventType: EventType){
        let deviceUsage = self.makeDeviceUsage(eventType: eventType)
        sendUsage(usage: deviceUsage, usageType: .device, credentials: self.credentials) { _ in
            self.dataPersistence.saveDeviceUsage(deviceUsage)
        }
    }
    
    func setAndMaybeAskForCorrectUser(){
        // Get current user
        currentUser = getCurrentUser()
        
        // Handle if it is the correct user
        let changeOfUserIsNeeded = !showChangeUserAlert(currentUser)
        
        if(changeOfUserIsNeeded){
            chooseUserWindow.showWindow(nil)
        }
        
        
        // In case it is updated
        currentUser = getCurrentUser()
    }
    
    func showNotification(title: String, informativeText: String) {
        let notification = NSUserNotification()
        notification.title = title
        notification.informativeText = informativeText
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(notification)
    }

    func setupReachability() {
        // Reachability
        reachability.whenReachable = { reachability in
            DispatchQueue.global(qos: .background).async {
                while(true) {
                    if(self.reachability.connection == Reachability.Connection.none) {
                        break
                    }
                    
                    self.maybeSendOldestSavedAppUsage()
                    self.maybeSendOldDeviceUsages()
                    
                    if self.useAppData {
                        if let lastAppUsage = self.maybeGetLastAppUsage() {
                            sendUsage(usage: lastAppUsage, usageType: .app, credentials: self.credentials) { _ in
                                // log error
                            }
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
                    
                    if self.useAppData {
                        if let lastAppUsage = self.maybeGetLastAppUsage() {
                            self.dataPersistence.saveAppUsage(lastAppUsage)
                        }
                    }
                    sleep(1)
                }
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start reachability notifier")
        }
    }
    
    func maybeSendOldestSavedAppUsage(){
        let oldestAppUsages = self.dataPersistence.retrieveSavedAppUsages()
        if !oldestAppUsages.isEmpty {
            print("Sending old app usages")
            sendUsages(usages: oldestAppUsages, usageType: .app, credentials: self.credentials) { (error) in
                print(error.debugDescription)
            }
        }
    }
    
    func maybeSendOldDeviceUsages(){
        let oldDeviceUsages = self.dataPersistence.retrieveSavedDeviceUsages()
        if !oldDeviceUsages.isEmpty {
            print("Sending old device usages")
            sendUsages(usages: oldDeviceUsages, usageType: .device, credentials: self.credentials) { (error) in
                print(error.debugDescription)
            }
        }
    }
}

