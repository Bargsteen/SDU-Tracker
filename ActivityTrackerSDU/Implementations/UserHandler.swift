//
//  UserHandler.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 27/09/2018.
//

import Foundation
import Cocoa

class UserHandler: UserHandlerProtocol, ChooseUserWindowClosedDelegate {
    private let alertHandler: AlertHandlerProtocol
    private let chooseUserWindow: ChooseUserWindowProtocol
    private var settings: SettingsProtocol
    
    private var userSessionChangesSubscribers: [UserSessionChangesDelegate]!
    
    private var showChooseUserWindowInvokedFromStatusMenu: Bool
    private var userBeforeChooseUserWindowWasShown: String
    
    init(alertHandler: AlertHandlerProtocol, chooseUserWindow: ChooseUserWindowProtocol,
         dateTimeHandler: DateTimeHandlerProtocol, settings: SettingsProtocol) {
        self.alertHandler = alertHandler
        self.chooseUserWindow = chooseUserWindow
        self.settings = settings
        
        self.userBeforeChooseUserWindowWasShown = settings.currentUser
        self.showChooseUserWindowInvokedFromStatusMenu = false
        
        self.userSessionChangesSubscribers = []
    }
    
    func checkIfUserHasChanged() {
        let currentUser = settings.currentUser
        if(settings.userCount > 1) {
            
            let changeOfUserIsNeeded = alertHandler.promptForUserChange(currentUser: currentUser)
            
            if(changeOfUserIsNeeded) {
                showChooseUserWindow(fromStatusMenu: false)
            } else {
                notifySubscribersOfUserSessionStarted(user: currentUser)
            }
        } else {
            notifySubscribersOfUserSessionStarted(user: currentUser)
        }
    }
    
    func onChooseUserWindowClosed() {
        let currentUser = settings.currentUser;
        
        if(showChooseUserWindowInvokedFromStatusMenu){
            
            if(currentUser != userBeforeChooseUserWindowWasShown) {
                
                notifySubscribersOfUserSessionEnded(user: userBeforeChooseUserWindowWasShown)
                notifySubscribersOfUserSessionStarted(user: currentUser)
                
            } // Else do nothing. User clicked change user, then decided not to.
            
        } else { // Invoked during a new computer session. Should just send the new user.
            
            notifySubscribersOfUserSessionStarted(user: currentUser)
            
        }
    }
    
    func subscribeToUserSessionChanges(subscriber: UserSessionChangesDelegate) {
        userSessionChangesSubscribers.append(subscriber)
    }
    
    private func notifySubscribersOfUserSessionEnded(user: String){
        userSessionChangesSubscribers.forEach { d in d.onUserSessionEnded(user: user) }
    }
    
    private func notifySubscribersOfUserSessionStarted(user: String){
        userSessionChangesSubscribers.forEach { d in d.onUserSessionStarted(user: user) }
    }
    
    func showChooseUserWindow(fromStatusMenu: Bool) {
        showChooseUserWindowInvokedFromStatusMenu = fromStatusMenu
        userBeforeChooseUserWindowWasShown = settings.currentUser
        
        chooseUserWindow.show(chooseUserWindowClosedDelegate: self)
    }
}
