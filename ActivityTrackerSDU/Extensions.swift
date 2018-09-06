//
//  Extensions.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 06/09/2018.
//

import Foundation

extension Array {
    mutating func maybeAppend(_ maybeElement: Element?) {
        if let element = maybeElement {
            self.append(element)
        }
    }
}
