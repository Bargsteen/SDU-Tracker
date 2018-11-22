//
//  UserSessionDelegate.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 22/11/2018.
//

import Foundation

protocol UserSessionChangesDelegate {
    func onUserSessionStarted(user: String)
    func onUserSessionEnded(user: String)
}
