//
//  StatusMenuController.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 17/08/2018.
//

import Cocoa
import Foundation

class StatusMenuController: NSObject{
    
    @IBOutlet weak var statusMenu: NSMenu!
    
    @IBOutlet weak var trackingType: NSMenuItem!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    override func awakeFromNib() {
        setupMenuValuesAndIcon()
    }

    
    // -- CLICK HANDLER FUNCTIONS
    @IBAction func chooseUserClicked(_ sender: NSMenuItem) {
        UserHandler.sharedInstance.showChooseUserWindow()
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
        
        trackingType.title = UserDefaultsHelper.getUseAppTracking() ? .trackingAppData : .trackingDeviceData
    }
    

    // -- ONLY USED FOR DEBUGGING
    
    @IBAction func toggleAppDeviceTrackingClicked(_ sender: NSMenuItem) {
        let useAppTracking = UserDefaultsHelper.getUseAppTracking()
        if(useAppTracking){
            trackingType.title = .trackingDeviceData
        } else {
            trackingType.title = .trackingAppData
        }
        UserDefaultsHelper.setUseAppTracking(!useAppTracking)
    }
}

