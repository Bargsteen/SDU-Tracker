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
    
    var isRunning = true
    
    let computerModel = Sysctl.model
    
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
        
        // Get current user
        var currentUser = getCurrentUser()
        
        // Handle if it is the correct user
        let changeOfUserIsNeeded = !showChangeUserAlert(currentUser)
        
        if(changeOfUserIsNeeded){
            chooseUserWindow.showWindow(nil)
        }
        
        // In case it is updated
        currentUser = getCurrentUser()
        
        ensureCredentialsAreSet()
        guard let credentials = loadCredentialsFromKeychain() else { ensureCredentialsAreSet(); return }
        
        // Reachability
        reachability.whenReachable = { reachability in
            DispatchQueue.global(qos: .background).async {
                while(true) {
                    let activeWindow = self.timeKeeper.maybeGetLastActiveWindow()
                    if let activeWindow = activeWindow {
                        let duration = activeWindow.endTime?.timeIntervalSince(activeWindow.startTime) ?? 0
                        let appUsage = AppUsage(participantIdentifier: currentUser, timeStamp: Date(), userCount: 1, deviceModelName: self.computerModel, package: activeWindow.bundleIdentifier, duration: duration.toMilliseconds())
                        sendUsage(usage: appUsage, usageType: .app, credentials: credentials) { (error) in
                            if let error = error {
                                //print(error)
                                // Log error
                            }
                        }
                    }
                    sleep(1)
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
    
    @IBAction func windowClicked(_ sender: NSMenuItem) {
        
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
    
    @IBAction func actionClicked(_ sender: NSMenuItem) {
        if(isRunning){
            action.title = "På Pause"
            isRunning = false
        } else {
            action.title = "Kører"
            isRunning = true
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
        addObserver(NSWorkspace.screensDidSleepNotification, "screens did SLEEP")
        addObserver(NSWorkspace.screensDidWakeNotification, "screens did WAKE")
        addObserver(NSWorkspace.didWakeNotification, "did WAKE")
        addObserver(NSWorkspace.sessionDidBecomeActiveNotification, "user SESSION STARTED")
        addObserver(NSWorkspace.sessionDidResignActiveNotification, "user SESSION ENDED")
    }
    
    func addObserver(_ n: Notification.Name?, _ msg: String) {
        NSWorkspace.shared.notificationCenter.addObserver(forName: n, object: nil, queue: nil, using: {(n:Notification) in print(msg)})
    }
}
