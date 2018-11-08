//
//  RequestHandlerProtocol.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 04/11/2018.
//

import Foundation

protocol RequestHandlerProtocol {
    func sendUsage<T:Usage>(usage: T, usageType: UsageType, credentials: Credentials, onSuccess:(() -> Void)?, onError: ((Error?) -> Void)?)
}
