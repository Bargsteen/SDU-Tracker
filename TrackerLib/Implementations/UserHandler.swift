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
    
    init(assembler: AssemblerProtocol) {
        self.alertHandler = assembler.resolve()
        self.chooseUserWindow = assembler.resolve()
        self.dateTimeHandler = assembler.resolve()
        self.settings = assembler.resolve()
        
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
    
    func notifyUserChangedListeners(newCurrentUser: String) {
        userChangedListeners.forEach { listener in listener.userChanged(newCurrentUser: newCurrentUser) }
    }

    
    func subscribeToUserChanges(_ newListener: UserChangedDelegate) {
        userChangedListeners.append(newListener)
    }
    
    func showChooseUserWindow() {
        chooseUserWindow.showWithCallback(onUserChange: notifyUserChangedListeners)
    }
}
