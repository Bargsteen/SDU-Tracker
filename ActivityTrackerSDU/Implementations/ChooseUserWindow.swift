//
//  ChooseUserWindow.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 28/08/2018.
//

import Cocoa

class ChooseUserWindow: NSWindowController, NSWindowDelegate, ChooseUserWindowProtocol, UserCreatedDelegate{
    
    private var settings: SettingsProtocol
    
    private var createUserWindow: CreateUserWindow
    
    @IBOutlet weak var userListMenu: NSPopUpButton!
    @IBOutlet weak var oneUserRequiredWarning: NSTextField!
    
    private var chooseUserWindowClosedDelegate: ChooseUserWindowClosedDelegate?
    
    // Used to keep track of changes before save button is pressed
    private var unsavedUserList: [String]!
    private var unsavedCurrentUser: String!
    
    private func stateIsValid() -> Bool {return !unsavedUserList.isEmpty && unsavedCurrentUser != "" }
    
    init(settings: SettingsProtocol) {
        self.settings = settings
        
        self.createUserWindow = CreateUserWindow()
        
        super.init(window: nil)
    }
    
    required init?(coder: NSCoder) {
        // Necessary hack to allow DI of SettingsProtocol in init.
        fatalError("init(coder:) has not been implemented. Use init()")
    }
    
    func show(chooseUserWindowClosedDelegate: ChooseUserWindowClosedDelegate){
        self.chooseUserWindowClosedDelegate = chooseUserWindowClosedDelegate
        self.showWindow(nil)
    }
    
    func userCreated(newUser: String) {
        self.unsavedUserList.append(newUser)
        
        if(unsavedCurrentUser.isEmpty) {
            unsavedCurrentUser = newUser
        }
        displayErrorIfStateIsInvalid()
        updateUserListMenuContents()
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
       
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        
        self.window?.title = "Brugerhåndtering"
        
        NSApp.activate(ignoringOtherApps: true)
        
        self.createUserWindow.userCreatedDelegate = self
        
        self.unsavedUserList = settings.userList
        self.unsavedCurrentUser = settings.currentUser
        
        displayErrorIfStateIsInvalid()
        
        updateUserListMenuContents()
    }
    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name("ChooseUserWindow")
    }

    func updateUserListMenuContents() {
        // Update the content of the userlist
        userListMenu.removeAllItems()
        userListMenu.addItems(withTitles: unsavedUserList)
        
        // Set selected to current user
        userListMenu.selectItem(withTitle: unsavedCurrentUser)
    }
    
    @IBAction func deleteChosenUserButtonClicked(_ sender: NSButton) {
        let chosenUser = getChosenUser()
        if let chosenUser = chosenUser {
            if let index = unsavedUserList.index(of: chosenUser) {
                unsavedUserList.remove(at: index)
                
                unsavedCurrentUser = unsavedUserList.first ?? ""
                
                displayErrorIfStateIsInvalid()
                
                updateUserListMenuContents()
            }
        }
    }
    
    private func displayErrorIfStateIsInvalid() {
        if(!stateIsValid()) {
            oneUserRequiredWarning.stringValue = "Du skal mindst have én bruger."
        } else {
            oneUserRequiredWarning.stringValue = ""
        }
    }
    
    @IBAction func createUserButtonClicked(_ sender: NSButton) {
        createUserWindow.show()
    }
    
    @IBAction func saveChangesButtonClicked(_ sender: NSButton) {
        let newCurrentUser = getChosenUser()
        
        if(stateIsValid()) {
            
            settings.userList = unsavedUserList
            
            // Set current user and notift listeners, if it has changed
            if let newCurrentUser = newCurrentUser {
                settings.currentUser = newCurrentUser
            }
            
            self.close()
        }
    }
    
    func windowWillClose(_ notification: Notification) {
        unsavedCurrentUser = settings.currentUser
        unsavedUserList = settings.userList
        updateUserListMenuContents()
        displayErrorIfStateIsInvalid()
        
        chooseUserWindowClosedDelegate?.onChooseUserWindowClosed()
    }

    private func getChosenUser() -> String? {
        return userListMenu.selectedItem?.title
    }
}
