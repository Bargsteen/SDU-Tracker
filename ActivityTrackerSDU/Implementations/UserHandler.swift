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
    private var settings: SettingsProtocol
    
    private var userSessionChangesSubscribers: [UserSessionChangesDelegate]!
    
    init(alertHandler: AlertHandlerProtocol, chooseUserWindow: ChooseUserWindowProtocol,
         dateTimeHandler: DateTimeHandlerProtocol, settings: SettingsProtocol) {
        self.alertHandler = alertHandler
        self.chooseUserWindow = chooseUserWindow
        self.settings = settings
        
        self.userSessionChangesSubscribers = []
    }
    
    func checkIfUserHasChanged() {
        let currentUser = settings.currentUser
        if(settings.userCount > 1) {
            
            let changeOfUserIsNeeded = alertHandler.promptForUserChange(currentUser: currentUser)
            
            if(changeOfUserIsNeeded) {
                showChooseUserWindow()
            } else {
                notifySubscribersOfUserSessionStarted(user: currentUser)
            }
        } else {
            notifySubscribersOfUserSessionStarted(user: currentUser)
        }
    }
    
    func subscribeToUserSessionChanges(_ subscriber: UserSessionChangesDelegate) {
        userSessionChangesSubscribers.append(subscriber)
    }
    
    private func notifySubscribersOfUserSessionEnded(user: String){
        userSessionChangesSubscribers.forEach { d in d.onUserSessionEnded(user: user) }
    }
    
    private func notifySubscribersOfUserSessionStarted(user: String){
        userSessionChangesSubscribers.forEach { d in d.onUserSessionStarted(user: user) }
    }
    
    func showChooseUserWindow() {
        chooseUserWindow.show()
    }
}
