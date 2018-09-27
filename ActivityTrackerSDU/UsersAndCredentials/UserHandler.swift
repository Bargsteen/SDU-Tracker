//
//  UserHandler.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 27/09/2018.
//

import Foundation
import Cocoa

public class UserHandler {
    
    var chooseUserWindow: ChooseUserWindow!
    
    init() {
        chooseUserWindow = ChooseUserWindow()
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
    
    func maybeAskAndSetCorrectUser(){
        if(UserDefaultsHelper.getUserCount() > 1) {
            let currentUser = UserDefaultsHelper.getCurrentUser()
            
            // Handle if it is the correct user
            let changeOfUserIsNeeded = !showChangeUserAlert(currentUser)
            
            if(changeOfUserIsNeeded){
                showChooseUserWindow()
            }
        }
    }
    
    func showChooseUserWindow() {
        chooseUserWindow.showWindow(nil)
    }
    
}
