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

extension TimeInterval {
    func toMilliseconds() -> UInt {
        return UInt(self * 1000)
    }
}

extension DeviceUsage {
    func getIdentifier() -> String {
        return "\(self.participantIdentifier)_\(self.timeStamp)_\(self.eventType)"
    }
}

extension AppUsage {
    func getIdentifier() -> String {
        return "\(self.participantIdentifier)_\(self.timeStamp)_\(self.package)"
    }
}

