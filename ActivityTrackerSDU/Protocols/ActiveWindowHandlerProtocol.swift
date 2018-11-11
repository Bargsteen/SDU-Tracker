//
//  ActiveWindowHandlerProtocol.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 04/11/2018.
//

import Foundation

protocol ActiveWindowHandlerProtocol {
    func maybeGetLastActiveWindow() -> ActiveWindow?
}
