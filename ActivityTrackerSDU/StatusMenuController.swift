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
<<<<<<< HEAD
    
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
=======
        dataPersistence = DataPersistence()
        
        // Get current user
        currentUser = getCurrentUser()
        
        // Handle if it is the correct user
        let changeOfUserIsNeeded = !showChangeUserAlert(currentUser)
        
        if(changeOfUserIsNeeded){
            chooseUserWindow.showWindow(nil)
        }
        
        // In case it is updated via the chooseUser popup window
        currentUser = getCurrentUser()
        
        setupReachability()
>>>>>>> Add offline-mode for appUsages
        
        ensureCredentialsAreSet()
        credentials = loadCredentialsFromKeychain()
    }
    
    func maybeGetLastAppUsage() -> AppUsage? {
        let activeWindow = self.timeKeeper.maybeGetLastActiveWindow()
        if let activeWindow = activeWindow {
            let duration = activeWindow.endTime?.timeIntervalSince(activeWindow.startTime) ?? 0
            return AppUsage(participantIdentifier: self.currentUser, timeStamp: Date(), userCount: 1, deviceModelName: self.computerModel, package: activeWindow.bundleIdentifier, duration: duration.toMilliseconds())
        }
<<<<<<< HEAD
        
        // Send app data if useAppData == true
        maybeSendDeviceUsageStarted()
    }
    
    func userHasChanged(_ nameOfUser : String) {
        print("Current user changed to: \(nameOfUser)")
=======
        return nil
    }
    
    func userHasChanged(_ nameOfUser : String) {
>>>>>>> Add offline-mode for appUsages
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
    
<<<<<<< HEAD
=======
    @IBAction func windowClicked(_ sender: NSMenuItem) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDir = paths.firstObject as! String
        print("Path to the Documents directory\n\(documentsDir)")
        
        //print(self.dataPersistence.maybeRetrieveSavedAppUsages())
    }
    
    
>>>>>>> Add offline-mode for appUsages
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
    
<<<<<<< HEAD
    @IBAction func toggleAppDeviceTrackingClicked(_ sender: NSMenuItem) {
        if(useAppData){
            action.title = .trackingDeviceData
            useAppData = false
        } else {
            action.title = .trackingAppData
            useAppData = true
            maybeSendDeviceUsageStarted()
=======
    @IBAction func actionClicked(_ sender: NSMenuItem) {
        if(isRunning){
            action.title = "På Pause"
            isRunning = false
        } else {
            action.title = "Kører"
            isRunning = true
>>>>>>> Add offline-mode for appUsages
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
    
<<<<<<< HEAD
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
=======
    func setupReachability() {
        // Reachability
        reachability.whenReachable = { reachability in
            DispatchQueue.global(qos: .background).async {
                while(true) {
                    if(self.reachability.connection == Reachability.Connection.none) {
                        break
                    }
                    print("I have internet!")
                    
                    self.maybeSendOldestSavedAppUsage()
                    
                    if let lastAppUsage = self.maybeGetLastAppUsage() {
                        sendUsage(usage: lastAppUsage, usageType: .app, credentials: self.credentials) { _ in
                            /*if let error = error {
                                print(error)cat
                            }*/
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
                    print("I DO NOT HAVE internet.")
                    if let lastAppUsage = self.maybeGetLastAppUsage() {
                        self.dataPersistence.saveAppUsage(lastAppUsage)
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
>>>>>>> Add offline-mode for appUsages
    }
}
