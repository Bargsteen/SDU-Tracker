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

    var thymeCommand : AsyncCommand!
    var isRunning = true
    
    var chooseUserWindow: ChooseUserWindow!
    
    @IBOutlet weak var action: NSMenuItem!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    override func awakeFromNib() {
        let icon = #imageLiteral(resourceName: "statusIcon")
        icon.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        // Choose User
        chooseUserWindow = ChooseUserWindow()
        chooseUserWindow.delegate = self
        
        // Get current user
        let defaults = UserDefaults.standard
        let currentUser = defaults.string(forKey: "currentUser") ?? "unavngivet bruger"
        
        // Handle if it is the correct user
        let changeOfUserIsNeeded = !showChangeUserAlert(currentUser)
        
        if(changeOfUserIsNeeded){
            chooseUserWindow.showWindow(nil)
        }
        
        runThymeAnew(currentUser)
    }
    
    func userHasChanged(_ nameOfUser : String) {
        print("Current user changed to: \(nameOfUser)")
        runThymeAnew(nameOfUser)
    }
    
    func showChangeUserAlert(_ currentUser : String) -> Bool {
        let alert = NSAlert()
        alert.messageText = "Er du \(currentUser)?"
        alert.informativeText = "Hvis ikke, så skift nuværende bruger:"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Fortsæt")
        alert.addButton(withTitle: "Skift Bruger")
        return alert.runModal() == .alertFirstButtonReturn
    }

    
    func runThymeAnew(_ user : String) {
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
}
