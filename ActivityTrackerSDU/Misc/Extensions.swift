//
//  Extensions.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 06/09/2018.
//

import Foundation

extension TimeInterval {
    func toMilliseconds() -> UInt {
        return UInt(self * 1000)
    }
}

extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
