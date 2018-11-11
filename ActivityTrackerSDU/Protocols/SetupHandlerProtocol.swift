//
//  SetupHandlerProtocol.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 07/11/2018.
//

import Foundation

protocol SetupHandlerProtocol {
    func parseUrlAndSetupApp(_ url : URL) -> Bool
    func showSetupResultAlert(succeeded: Bool)
}
