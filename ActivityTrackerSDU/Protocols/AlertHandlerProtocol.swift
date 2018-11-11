//
//  AlertHandlerProtocol.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 04/11/2018.
//

import Foundation

protocol AlertHandlerProtocol {
    func promptForUserChange(currentUser: String) -> Bool
    func showTrackingPeriodHasEndedAlert()
    func showApplicationReadyForSetupLinkAlert()
}
