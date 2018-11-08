//
//  UserHandler.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 04/11/2018.
//

import Foundation

protocol UserHandlerProtocol {
    func checkIfUserHasChanged()
    func subscribeToUserChanges(_ newListener: UserChangedDelegate)
    func showChooseUserWindow()
}
