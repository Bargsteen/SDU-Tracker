//
//  UserWindowProtocol.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 04/11/2018.
//

import Foundation
import Cocoa

protocol UserWindowProtocol {
    func show(userWindowClosedDelegate: UserWindowClosedDelegate)
}
