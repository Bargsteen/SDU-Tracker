//
//  StatusMenuController.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 17/08/2018.
//

import Cocoa
import Foundation
import CwlUtils

class StatusMenuController: NSObject{
    
    @IBOutlet weak var statusMenu: NSMenu!

    var tracking: Tracking!
    var userHandler: UserHandler!
    
    @IBOutlet weak var trackingType: NSMenuItem!
    @IBOutlet weak var notificationSetting: NSMenuItem!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    override func awakeFromNib() {
        setupMenuValuesAndIcon()
        
        userHandler = UserHandler()
        tracking = Tracking(userHandler: userHandler)
        tracking.setupTracking()
    
        userHandler.maybeAskAndSetCorrectUser()
        
        CredentialHandler.ensureCredentialsAreSet()
        
        // Set Defaults. TODO: Move to somewhere more relevant
        UserDefaultsHelper.setDeviceModelName(Sysctl.model)

    }

    
    // -- CLICK HANDLER FUNCTIONS
    @IBAction func chooseUserClicked(_ sender: NSMenuItem) {
        userHandler.showChooseUserWindow()
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
        notificationSetting.title = UserDefaultsHelper.getShowNotificationsSetting() ? .notificationsEnabled : .notificationsDisabled
    }
    

    // -- ONLY USED FOR DEBUGGING
    @IBAction func deleteCredentialsClicked(_ sender: NSMenuItem) {
        do {
            try CredentialHandler.deleteCredentialsFromKeychain()
        } catch {
        }
    }
    
    @IBAction func showDBContentClicked(_ sender: NSMenuItem) {
        printSavedAppUsages()
    }
    
    @IBAction func notificationSettingClicked(_ sender: NSMenuItem) {
        let showNotifications = UserDefaultsHelper.getShowNotificationsSetting()
        if(showNotifications){
            notificationSetting.title = .notificationsDisabled
            
        } else {
            notificationSetting.title = .notificationsEnabled
        }
        UserDefaultsHelper.setShowNotificationsSetting(!showNotifications)
    }
    
    func printSavedAppUsages() {
        let appUsages = Persistence.fetchAllAppUsages().sorted {(first, second) in first.timeStamp <= second.timeStamp }
        appUsages.forEach {usage in print("\(usage.timeStamp) -- \(usage.package)") }
    }
    
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

