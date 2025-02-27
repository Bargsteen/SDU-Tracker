//
//  UserHandler.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 04/11/2018.
//

import Foundation

protocol UserHandlerProtocol {
    func checkIfUserHasChanged()
    func showUserWindow(fromStatusMenu: Bool)
    func subscribeToUserSessionChanges(subscriber: UserSessionChangesDelegate)
}
