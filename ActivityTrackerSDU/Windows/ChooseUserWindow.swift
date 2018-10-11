//
//  ChooseUserWindow.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 28/08/2018.
//

import Cocoa

protocol ChooseUserWindowDelegate {
    func userHasChanged(_ nameOfUser: String)
}

class ChooseUserWindow: NSWindowController, NSWindowDelegate{
    
    @IBOutlet weak var userListMenu: NSPopUpButton!
    @IBOutlet weak var newUserTextField: NSTextField!
    
    var delegate: ChooseUserWindowDelegate?
    
    override func windowDidLoad() {
        super.windowDidLoad()
       
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        
        NSApp.activate(ignoringOtherApps: true)
        
        updateUserListMenu()
    }
    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name("ChooseUserWindow")
    }
    
    func updateUserListMenu() {
        let defaults = UserDefaults.standard
        let users = defaults.stringArray(forKey: "users") ?? ["Opret en bruger først"]
        
        // Update the content of the userlist
        userListMenu.removeAllItems()
        userListMenu.addItems(withTitles: users)
        
        // Set selected to current user
        let maybeCurrentUser = defaults.string(forKey: "currentUser")
        if let currentUser = maybeCurrentUser {
            userListMenu.selectItem(withTitle: currentUser)
        }
    }
    
    @IBAction func newUserButtonClicked(_ sender: NSButton) {
        let newUserName = newUserTextField.stringValue;
        if(!newUserName.isEmpty){
            let userList = UserDefaultsHelper.getUsers()
            let updatedUserList = userList + [newUserName]
            UserDefaultsHelper.setUsers(updatedUserList)
            newUserTextField.stringValue = ""
            updateUserListMenu()
        }
    }
    
    func windowWillClose(_ notification: Notification) {
        let currentUser = UserDefaultsHelper.getCurrentUser()
        let newCurrentUser : String = userListMenu.selectedItem?.title ?? .unnamedUser
        
        if(currentUser != newCurrentUser) {
            UserDefaultsHelper.setCurrentUser(newCurrentUser)
            delegate?.userHasChanged(newCurrentUser)
        }
    }
    
}
