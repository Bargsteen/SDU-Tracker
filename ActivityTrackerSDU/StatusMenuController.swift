//
//  StatusMenuController.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 17/08/2018.
//

import Cocoa
import SwiftShell
import Foundation

class StatusMenuController: NSObject {
    
    @IBOutlet weak var statusMenu: NSMenu!

    let thymeCommand = runAsync(bash: "now=$(date +\"%Y_%m_%d_%X\"); while true; do /Users/kasper/go/bin/thyme track -o \"SDU_ActivityTracker_$now.json\" ; wait 10s ; done")
    var isRunning = true;
    
    
    @IBOutlet weak var action: NSMenuItem!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    override func awakeFromNib() {
        let icon = #imageLiteral(resourceName: "statusIcon")
        icon.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
    }
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func actionClicked(_ sender: NSMenuItem) {
        print(run(bash:"pwd").stdout)
        if(isRunning){
            action.title = "Suspended"
            thymeCommand.suspend()
            isRunning = false
        } else {
            action.title = "Running"
            thymeCommand.resume()
            isRunning = true
        }
    }
}
