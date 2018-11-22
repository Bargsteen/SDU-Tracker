//
//  SettingsProtocol.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 04/11/2018.
//

import Foundation

protocol SettingsProtocol {
    var appHasBeenSetup: Bool { get set }
    
    func subscribeToAppHasBeenSetupChanges(subscriber: AppHasBeenSetupDelegate)
    
    var userList: [String] { get set }
    
    var userCount: Int { get }
    var currentUser: String { get set }
    
    var deviceModelName: String { get }
    
    var trackingType: TrackingType { get set }
    
    var stopTrackingDate: Date { get set }
    
    var userId: String { get set }
    var participantIdentifier: String { get}
    
    func makeParticipantIdentifierForSpecificUser(user: String) -> String
    
    var credentials: Credentials { get }
}
