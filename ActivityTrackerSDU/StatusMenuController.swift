//
//  StatusMenuController.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 17/08/2018.
//

import Cocoa
import Foundation

class StatusMenuController: NSObject, UserChangedDelegate {
    
    @IBOutlet private weak var statusMenu: NSMenu!

    @IBOutlet private weak var currentUserMenuItem: NSMenuItem!
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    private let userHandler: UserHandlerProtocol
    private let settings: SettingsProtocol
    
    override init() {
        let assembler: AssemblerProtocol = Assembler()
        
        self.userHandler = assembler.resolve()
        self.settings = assembler.resolve()
        
        super.init()
        
    }
    
    override func awakeFromNib() {
        setupMenuValuesAndIcon()
        userHandler.subscribeToUserChanges(self)
    }

    
    // -- CLICK HANDLER FUNCTIONS
    @IBAction func chooseUserClicked(_ sender: NSMenuItem) {
        userHandler.showChooseUserWindow()
    }
    
    func userChanged(newCurrentUser: String) {
        currentUserMenuItem.title = "Bruger: " + newCurrentUser
    }
    
    
    // Local helpers
    func setupMenuValuesAndIcon() {
        let icon = #imageLiteral(resourceName: "statusIcon")
        icon.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        currentUserMenuItem.title = "Bruger: " + settings.currentUser
    }
}

