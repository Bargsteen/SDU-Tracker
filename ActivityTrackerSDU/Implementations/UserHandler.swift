//
//  UserHandler.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 27/09/2018.
//

import Foundation
import Cocoa

class UserHandler: UserHandlerProtocol, UserWindowClosedDelegate {
    private let alertHandler: AlertHandlerProtocol
    private let userWindow: UserWindowProtocol
    private var settings: SettingsProtocol
    
    private var userSessionChangesSubscribers: [UserSessionChangesDelegate]!
    
    private var showUserWindowInvokedFromStatusMenu: Bool
    private var userBeforeUserWindowWasShown: String
    
    init(alertHandler: AlertHandlerProtocol, userWindow: UserWindowProtocol,
         dateTimeHandler: DateTimeHandlerProtocol, settings: SettingsProtocol) {
        self.alertHandler = alertHandler
        self.userWindow = userWindow
        self.settings = settings
        
        self.userBeforeUserWindowWasShown = settings.currentUser
        self.showUserWindowInvokedFromStatusMenu = false
        
        self.userSessionChangesSubscribers = []
    }
    
    func checkIfUserHasChanged() {
        let currentUser = settings.currentUser
        if(settings.userCount > 1) {
            
            let changeOfUserIsNeeded = alertHandler.promptForUserChange(currentUser: currentUser)
            
            if(changeOfUserIsNeeded) {
                showUserWindow(fromStatusMenu: false)
            } else {
                notifySubscribersOfUserSessionStarted(user: currentUser)
            }
        } else {
            notifySubscribersOfUserSessionStarted(user: currentUser)
        }
    }
    
    func onUserWindowClosed() {
        let currentUser = settings.currentUser;
        
        if(showUserWindowInvokedFromStatusMenu){
            
            if(currentUser != userBeforeUserWindowWasShown) {
                
                notifySubscribersOfUserSessionEnded(user: userBeforeUserWindowWasShown)
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
    
    func showUserWindow(fromStatusMenu: Bool) {
        showUserWindowInvokedFromStatusMenu = fromStatusMenu
        userBeforeUserWindowWasShown = settings.currentUser
        
        userWindow.show(userWindowClosedDelegate: self)
    }
}
