//
//  ChooseUserWindow.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 28/08/2018.
//

import Cocoa

class ChooseUserWindow: NSWindowController, NSWindowDelegate, ChooseUserWindowProtocol{
    
    private var settings: SettingsProtocol
    
    private var onUserChangeCallBack : ((String) -> ())?
    
    @IBOutlet weak var userListMenu: NSPopUpButton!
    @IBOutlet weak var newUserTextField: NSTextField!
    
    init(assembler: AssemblerProtocol) {
        self.settings = assembler.resolve()
        super.init(window: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Use init()")
    }
    
    func showWithCallback(onUserChange: @escaping (String) -> ()){
        self.showWindow(nil)
        onUserChangeCallBack = onUserChange
    }
    
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
        let userList = settings.userList
        
        // Update the content of the userlist
        userListMenu.removeAllItems()
        userListMenu.addItems(withTitles: userList)
        
        // Set selected to current user
        let currentUser = settings.currentUser
        userListMenu.selectItem(withTitle: currentUser)
    }
    
    @IBAction func newUserButtonClicked(_ sender: NSButton) {
        let newUsername = newUserTextField.stringValue;
        if(!newUsername.isEmpty){
            
            settings.addUser(nameOfUser: newUsername)
            
            updateUserListMenu()
            
            // Clear text field
            newUserTextField.stringValue = ""
        }
    }
    
    func windowWillClose(_ notification: Notification) {
        let currentUser = settings.currentUser
        let newCurrentUser = userListMenu.selectedItem?.title
        
        if let newCurrentUser = newCurrentUser {
            if(newCurrentUser != currentUser) {
                settings.currentUser = newCurrentUser
                onUserChangeCallBack?(newCurrentUser)
            }
        }
    }
    
}
