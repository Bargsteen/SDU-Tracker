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

    @IBOutlet weak var trackingTypeMenuItem: NSMenuItem!
    @IBOutlet weak var currentUserMenuItem: NSMenuItem!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    override func awakeFromNib() {
        setupMenuValuesAndIcon()
        UserHandler.sharedInstance.subscribeToUserChangedNotifications(delegate: self)
    }

    
    // -- CLICK HANDLER FUNCTIONS
    @IBAction func chooseUserClicked(_ sender: NSMenuItem) {
        UserHandler.sharedInstance.showChooseUserWindow()
    }
    
    func userHasChanged(_ nameOfUser: String) {
        currentUserMenuItem.title = "Bruger: " + nameOfUser
    }
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    // Local helpers
    func setupMenuValuesAndIcon() {
        let icon = #imageLiteral(resourceName: "statusIcon")
        icon.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        trackingTypeMenuItem.title = UserDefaultsHelper.getUseAppTracking() ? .trackingAppData : .trackingDeviceData
        
        currentUserMenuItem.title = "Bruger: " + UserDefaultsHelper.getCurrentUser()
    }
    

    // -- ONLY USED FOR DEBUGGING
    
    @IBAction func toggleAppDeviceTrackingClicked(_ sender: NSMenuItem) {
        let useAppTracking = UserDefaultsHelper.getUseAppTracking()
        if(useAppTracking){
            trackingTypeMenuItem.title = .trackingDeviceData
        } else {
            trackingTypeMenuItem.title = .trackingAppData
        }
        UserDefaultsHelper.setUseAppTracking(!useAppTracking)
    }
}

