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
        
        // TimeKeeper
        timeKeeper = TimeKeeper()
    
        // Observe changes such as screen awake / asleep
        setUpNotificationObservers()
        
        setAndMaybeAskForCorrectUser()
        
        ensureCredentialsAreSet()
        self.credentials = loadCredentialsFromKeychain()
        
        // Reachability
        reachability.whenReachable = { reachability in
            DispatchQueue.global(qos: .background).async {
                while(true) {
                    if(self.useAppData){
                        let activeWindow = self.timeKeeper.maybeGetLastActiveWindow()
                        if let activeWindow = activeWindow {
                            let duration = activeWindow.endTime?.timeIntervalSince(activeWindow.startTime) ?? 0
                            let appUsage = AppUsage(participantIdentifier: self.currentUser, timeStamp: Date(), userCount: 1, deviceModelName: self.deviceModelName, package: activeWindow.bundleIdentifier, duration: duration.toMilliseconds())
                            sendUsage(usage: appUsage, usageType: .app, credentials: self.credentials) { (error) in
    //                            if let error = error {
    //                                //print(error)
    //                                // Log error
    //                            }
                            }
                        }
                        sleep(1)
                    }
                }
            }
        }
        reachability.whenUnreachable = { _ in
            print("I have no internet..")
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start reachability notifier")
        }
        
        // Send app data if useAppData == true
        maybeSendDeviceUsageStarted()
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

    @IBAction func sendRequestClicked(_ sender: NSMenuItem) {
        guard let credentials = loadCredentialsFromKeychain() else { ensureCredentialsAreSet(); return }
        let currentUser = getCurrentUser()
        //let myActivity = DeviceUsage(participantIdentifier: currentUser, eventType: EventType.started, timeStamp: Date(), userCount: 1, deviceModelName: "Mac")
        let appUsage = AppUsage(participantIdentifier: currentUser, timeStamp: Date(), userCount: 1, deviceModelName: "MacBook Pro Retina", package: "XCode", duration: 1000)
        if(reachability.connection != .none) {
            sendUsage(usage: appUsage, usageType: .app, credentials: credentials) { (error) in
                if let error = error {
                    fatalError(error.localizedDescription)
                }
            }
        } else {
            print("Can't send request, because I don't have internet.")
        }
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
        } else {
            action.title = .trackingAppData
            useAppData = true
            maybeSendDeviceUsageStarted()
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
    
    func setUpNotificationObservers() {
        
        let notificationCenter = NSWorkspace.shared.notificationCenter
        
        // Handle waking aka Session start
        notificationCenter.addObserver(forName: NSWorkspace.screensDidWakeNotification, object: nil, queue: nil, using: {(n:Notification) in
            if(!self.useAppData) {
                let deviceUsage = self.makeDeviceUsage(eventType: EventType.started)
                self.showNotification(title: "Waking", informativeText: "Woke up at \(Date())")
                sendUsage(usage: deviceUsage, usageType: .device, credentials: self.credentials) { _ in
                    // TODO: Save in persistent storage
                    self.showNotification(title: "Fail: Waking", informativeText: "Could not send wake data")
                }
            }
        })
        
        // Handle sleeping aka Session end
        notificationCenter.addObserver(forName: NSWorkspace.screensDidSleepNotification, object: nil, queue: nil, using: {(n:Notification) in
            if (!self.useAppData) {
                let deviceUsage = self.makeDeviceUsage(eventType: EventType.ended)
                self.showNotification(title: "Sleep", informativeText: "Went to sleep at \(Date())")
                sendUsage(usage: deviceUsage, usageType: .device, credentials: self.credentials) { _ in
                    // TODO: Save in persistent storage
                    self.showNotification(title: "Fail: Sleeping", informativeText: "Could not send sleep data")
                }
            }
        })
    }
    
    func makeDeviceUsage(eventType: EventType) -> DeviceUsage {
        return DeviceUsage(participantIdentifier: self.currentUser, eventType: eventType, timeStamp: Date(), userCount: getUserCount(), deviceModelName: self.deviceModelName)
    }
    
    func getUserCount() -> Int {
        let userList = UserDefaults.standard.stringArray(forKey: "users")
        
        return userList?.count ?? 0
    }
    
    func maybeSendDeviceUsageStarted(){
        if(!self.useAppData) {
            let deviceUsage = self.makeDeviceUsage(eventType: EventType.started)
            //self.showNotification(title: "Waking", informativeText: "Woke up at \(Date())")
            sendUsage(usage: deviceUsage, usageType: .device, credentials: self.credentials) { _ in
                // TODO: Save in persistent storage
                self.showNotification(title: "Fail: Waking", informativeText: "Could not send wake data")
            }
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
}
