//
//  SendOrSaveHandlerProtocol.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 04/11/2018.
//

import Foundation

protocol SendOrSaveHandlerProtocol {
    func sendOrSaveUsage<T: Usage>(usage: T, fromPersistence: Bool)
    func sendSomeSavedUsages(limitOfEach: Int)
}
