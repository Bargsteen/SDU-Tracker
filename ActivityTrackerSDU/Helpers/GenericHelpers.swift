//
//  GenericHelpers.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 18/09/2018.
//

import Foundation


func firstAndThen(first: (() -> Void), andThen: (() -> Void)) {
    first()
    andThen()
}
