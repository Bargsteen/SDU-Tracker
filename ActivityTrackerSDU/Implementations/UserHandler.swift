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
    
    init(alertHandler: AlertHandlerProtocol, chooseUserWindow: ChooseUserWindowProtocol,
         dateTimeHandler: DateTimeHandlerProtocol, settings: SettingsProtocol) {
        self.alertHandler = alertHandler
        self.chooseUserWindow = chooseUserWindow
        self.dateTimeHandler = dateTimeHandler
        self.settings = settings
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
    
    func showChooseUserWindow() {
        chooseUserWindow.show()
    }
}
