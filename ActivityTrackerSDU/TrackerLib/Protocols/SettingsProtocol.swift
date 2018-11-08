//
//  SettingsProtocol.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 04/11/2018.
//

import Foundation

protocol SettingsProtocol {
    var appHasBeenSetup: Bool { get set }
    
    var userList: [String] { get }
    func addUser(nameOfUser: String)
    func removeUser(nameOfUser: String)
    var userCount: Int { get }
    var currentUser: String { get set }
    
    var deviceModelName: String { get }
    
    var trackingType: TrackingType { get set }
    
    var stopTrackingDate: Date { get set }
    
    var userId: String { get set }
    var participantIdentifier: String { get}
    
    var credentials: Credentials { get }
}
