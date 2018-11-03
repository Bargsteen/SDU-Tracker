//
//  UserHandler.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 27/09/2018.
//

import Foundation
import Cocoa

public class UserHandler {
    
    static let sharedInstance = UserHandler()
    
    var chooseUserWindow: ChooseUserWindow!
    var lastChangeUserAlertTime: Date
    
    init() {
        chooseUserWindow = ChooseUserWindow()
        lastChangeUserAlertTime = Date.distantPast
    }
    
    func showChangeUserAlert(_ currentUser : String) -> Bool {
        
        let now = Date.init()
        let timeSinceLastAlert = now.timeIntervalSince(lastChangeUserAlertTime)
        
        // Checks time to avoid showing multiple alerts in a row
        if timeSinceLastAlert.toMilliseconds() > UInt32.changeUserAlertInterval {
            let alert = NSAlert()
            alert.messageText = "Er du \(currentUser)?"
            alert.informativeText = "Hvis ikke, så skift nuværende bruger."
            alert.alertStyle = .informational
            alert.addButton(withTitle: "Ja, det er mig")
            alert.addButton(withTitle: "Nej, skift bruger")
            
            var shouldShowChooseUserWindow = false
            
            // Stops the modal after changeUserAlertTimeDisplayed seconds and returns false, i.e. do not change the user.
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double.changeUserAlertTimeDisplayed) {
                NSApplication.shared.stopModal()
            }
            
            // Show the modal and wait up to x seconds for a click.
            shouldShowChooseUserWindow = alert.runModal() == .alertSecondButtonReturn
            
            lastChangeUserAlertTime = Date.init()
            
            return shouldShowChooseUserWindow
        }
        return false
    }
    
    func maybeAskAndSetCorrectUser(){
        if(UserDefaultsHelper.getUserCount() > 1) {
            let currentUser = UserDefaultsHelper.getCurrentUser()
            
            // Handle if it is the correct user
            let changeOfUserIsNeeded = showChangeUserAlert(currentUser)
            
            if(changeOfUserIsNeeded){
                showChooseUserWindow()
            }
        }
    }
    
    func subscribeToUserChangedNotifications(delegate: ChooseUserWindowDelegate) {
        chooseUserWindow.delegate = delegate
    }
    
    func showChooseUserWindow() {
        chooseUserWindow.showWindow(nil)
    }
    
}
