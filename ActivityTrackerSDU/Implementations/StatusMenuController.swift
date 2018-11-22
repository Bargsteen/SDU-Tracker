//
//  StatusMenuController.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 17/08/2018.
//

import Cocoa
import Foundation

class StatusMenuController: NSObject, UserSessionChangesDelegate {
    
    @IBOutlet private weak var statusMenu: NSMenu!

    @IBOutlet private weak var currentUserMenuItem: NSMenuItem!
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    private var userHandler: UserHandlerProtocol
    private var settings: SettingsProtocol
    
    override init() {
        self.userHandler = container.resolve(UserHandlerProtocol.self)!
        self.settings = container.resolve(SettingsProtocol.self)!
        
        super.init()
    }
    
    override func awakeFromNib() {
        setupMenuValuesAndIcon()
    }
    
    // -- CLICK HANDLER FUNCTIONS
    @IBAction func chooseUserClicked(_ sender: NSMenuItem) {
        if(settings.appHasBeenSetup) {
            userHandler.showChooseUserWindow()
        }
    }
    
    func onUserSessionStarted(user: String) {
        currentUserMenuItem.title = "Valgte bruger: " + user
    }
    
    func onUserSessionEnded(user: String) {
        // Not needed
    }
    
    func setupMenuValuesAndIcon() {
        let icon = #imageLiteral(resourceName: "statusIcon")
        icon.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        if(settings.appHasBeenSetup){
            currentUserMenuItem.title = "Valgte bruger: " + settings.currentUser
        } else {
            currentUserMenuItem.title = "Mangler opsætning"
        }
    }
}

