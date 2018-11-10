//
//  UserHandler.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 27/09/2018.
//

import Foundation
import Cocoa

class UserHandler: UserHandlerProtocol {
    
    private let alertHandler: AlertHandlerProtocol
    private let chooseUserWindow: ChooseUserWindowProtocol
    private let dateTimeHandler: DateTimeHandlerProtocol
    private var settings: SettingsProtocol
    
    var userChangedListeners: [UserChangedDelegate]
    
    init(alertHandler: AlertHandlerProtocol, chooseUserWindow: ChooseUserWindowProtocol,
         dateTimeHandler: DateTimeHandlerProtocol, settings: SettingsProtocol) {
        self.alertHandler = alertHandler
        self.chooseUserWindow = chooseUserWindow
        self.dateTimeHandler = dateTimeHandler
        self.settings = settings
        
        userChangedListeners = []
    }
    
    func checkIfUserHasChanged() {
        if(settings.userCount > 1) {
            let currentUser = settings.currentUser
            
            let changeOfUserIsNeeded = alertHandler.promptForUserChange(currentUser: currentUser)
            
            if(changeOfUserIsNeeded) {
                showChooseUserWindow()
            }
        }
    }
    
    func notifyUserChangedListeners(previousUser: String, newUser: String) {
        userChangedListeners.forEach { listener in listener.userChanged(previousUser:previousUser, newUser: newUser) }
    }

    
    func subscribeToUserChanges(_ newListener: UserChangedDelegate) {
        userChangedListeners.append(newListener)
    }
    
    func showChooseUserWindow() {
        chooseUserWindow.showWithCallback(onUserChange: notifyUserChangedListeners)
    }
}
