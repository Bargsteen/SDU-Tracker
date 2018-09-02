//
//  StatusMenuController.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 17/08/2018.
//

import Cocoa
import SwiftShell
import Foundation

class StatusMenuController: NSObject, ChooseUserWindowDelegate {
    
    @IBOutlet weak var statusMenu: NSMenu!
    
    let reachability = Reachability()!

    var thymeCommand : AsyncCommand!
    var isRunning = true
    
    var chooseUserWindow: ChooseUserWindow!
    var credentialsWindow: CredentialsWindow!
    
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
        
        runThymeAnew(currentUser)
        
        
        // Reachability
        reachability.whenReachable = { reachability in
            print("I have internet!")
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
        runThymeAnew(nameOfUser)
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
        let myActivity = Activity(participantIdentifier: currentUser, eventType: EventType.started, timeStamp: Date(), userCount: 1, deviceModelName: "Mac")
        if(reachability.connection != .none) {
            sendActivity(activity: myActivity, credentials: credentials) { (error) in
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
    
    func runThymeAnew(_ user : String) {
        print("Running Thyme with user: \(user)")
        thymeCommand = runAsync(bash: "now=$(date +\"%Y_%m_%d_%X\"); while true; do /Users/kasper/go/bin/thyme track -o \"SDU_ActivityTracker_${now}_\(user).json\" ; wait 10s ; done")
    }
    
    @IBAction func chooseUserClicked(_ sender: NSMenuItem) {
        chooseUserWindow.showWindow(nil)
    }
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func actionClicked(_ sender: NSMenuItem) {
        print(run(bash:"pwd").stdout)
        if(isRunning){
            action.title = "På Pause"
            thymeCommand.suspend()
            isRunning = false
        } else {
            action.title = "Kører"
            thymeCommand.resume()
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
}
