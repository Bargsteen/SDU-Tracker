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

class StatusMenuController: NSObject, ChooseUserWindowDelegate {
    
    @IBOutlet weak var statusMenu: NSMenu!
    
    let reachability = Reachability()!
    
    var useAppData = true
    
    let deviceModelName = Sysctl.model
    var currentUser : String = .unnamedUser
    var credentials : Credentials!
    
    var chooseUserWindow: ChooseUserWindow!
    var credentialsWindow: CredentialsWindow!
    
    var timeKeeper : TimeKeeper!
    
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
        
        action.title = useAppData ? .trackingAppData : .trackingDeviceData
        
        // Initialization
        timeKeeper = TimeKeeper()
    
        setAndMaybeAskForCorrectUser()
        
        ensureCredentialsAreSet()
        if let credentials = loadCredentialsFromKeychain() {
            self.credentials = credentials
            
            setUpDeviceUsageTracking()
            
            setupAppUsageTracking()
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
    
    // Used only for testing
    @IBAction func deleteCredentialsClicked(_ sender: NSMenuItem) {
        do {
            try deleteCredentialsFromKeychain()
        } catch {
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
        
        if !self.useAppData {
            self.sendDeviceUsage(eventType: .started)
        }
        
        let notificationCenter = NSWorkspace.shared.notificationCenter
        
        // Handle waking aka Session start
        notificationCenter.addObserver(forName: NSWorkspace.screensDidWakeNotification, object: nil, queue: nil, using: {(n:Notification) in
            
            self.setAndMaybeAskForCorrectUser()
            
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
        sendUsage(usage: deviceUsage, usageType: .device, credentials: self.credentials, onSuccess: nil) { _ in
            Persistence.save(deviceUsage)
        }
    }
    
    func setAndMaybeAskForCorrectUser(){
        // Get current user
        currentUser = getCurrentUser()
        
        if(getUserCount() > 1) {
            // Handle if it is the correct user
            let changeOfUserIsNeeded = !showChangeUserAlert(currentUser)
            
            if(changeOfUserIsNeeded){
                chooseUserWindow.showWindow(nil)
            }
            
            
            // In case it is updated
            currentUser = getCurrentUser()
        }        
    }
    
    func showNotification(title: String, informativeText: String) {
        let notification = NSUserNotification()
        notification.title = title
        notification.informativeText = informativeText
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    func setupAppUsageTracking() {
        // Reachability
        reachability.whenReachable = { reachability in
            DispatchQueue.global(qos: .background).async {
                
                
                while(true) {
                    if(self.reachability.connection == Reachability.Connection.none) {
                        break
                    }
                    
                    // TODO: Only check DB if flag has been set to do so
                    self.maybeSendOldestSavedAppUsage()
                    self.maybeSendOldDeviceUsages()
                    
                    if self.useAppData {
                        if let lastAppUsage = self.maybeGetLastAppUsage() {
                            sendUsage(usage: lastAppUsage, usageType: .app, credentials: self.credentials
                                , onSuccess: { print("SENT: \(lastAppUsage.package)")}
                                , onError: { _ in
                                    print("SAVED: \(lastAppUsage.package)")
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
                    
                    if self.useAppData {
                        if let lastAppUsage = self.maybeGetLastAppUsage() {
                            print("SAVED: \(lastAppUsage.package)")
                            Persistence.save(lastAppUsage)
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
        if let oldestAppUsage = Persistence.maybeRetrieveOldestAppUsage() {
            sendUsage(usage: oldestAppUsage, usageType: .app, credentials: self.credentials,
                      onSuccess: {
                        print("SENT SAVED: \(oldestAppUsage.package)")
                        Persistence.deleteAppUsage(oldestAppUsage.getIdentifier())},
                      onError: nil // TODO: Perhaps do nothing?
            )
        }
    }
    
    func maybeSendOldDeviceUsages(){
        if let oldestDeviceUsage = Persistence.maybeRetrieveOldestDeviceUsage() {
            sendUsage(usage: oldestDeviceUsage, usageType: .device, credentials: self.credentials,
                      onSuccess: { Persistence.deleteDeviceUsage(oldestDeviceUsage.getIdentifier())},
                      onError: nil // TODO: Perhaps do nothing?
            )
        }
    }
}

