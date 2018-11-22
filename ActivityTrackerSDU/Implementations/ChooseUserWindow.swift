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
    private var localUserList: [String]!
    private var localCurrentUser: String!
    
    private func stateIsValid() -> Bool {return !localUserList.isEmpty && localCurrentUser != "" }
    
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
        self.localUserList.append(newUser)
        
        if(localCurrentUser.isEmpty) {
            localCurrentUser = newUser
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
        
        self.localUserList = settings.userList
        self.localCurrentUser = settings.currentUser
        
        displayErrorIfStateIsInvalid()
        
        updateUserListMenuContents()
    }
    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name("ChooseUserWindow")
    }

    func updateUserListMenuContents() {
        // Update the content of the userlist
        userListMenu.removeAllItems()
        userListMenu.addItems(withTitles: localUserList)
        
        // Set selected to current user
        userListMenu.selectItem(withTitle: localCurrentUser)
    }
    
    @IBAction func deleteChosenUserButtonClicked(_ sender: NSButton) {
        let chosenUser = getChosenUser()
        if let chosenUser = chosenUser {
            if let index = localUserList.index(of: chosenUser) {
                localUserList.remove(at: index)
                
                localCurrentUser = localUserList.first ?? ""
                
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
            
            // Changes to the userlist requires a confirmation
            if(settings.userList.count != localUserList.count || settings.userList.sorted() != localUserList.sorted()) {
                let isSure = showAreYouSurePrompt()
                if(isSure) {
                    settings.userList = localUserList
                }
            }
            
            // Set current user and notift listeners, if it has changed
            if let newCurrentUser = newCurrentUser {
                let previousCurrentUser = settings.currentUser
                if(newCurrentUser != previousCurrentUser) {
                    settings.currentUser = newCurrentUser
                }
            }
            
            self.close()
        }
    }
    
    func windowWillClose(_ notification: Notification) {
        localCurrentUser = settings.currentUser
        localUserList = settings.userList
        updateUserListMenuContents()
        displayErrorIfStateIsInvalid()
        
        chooseUserWindowClosedDelegate?.onChooseUserWindowClosed()
    }
    
    private func showAreYouSurePrompt() -> Bool {
        let alert = NSAlert()
        alert.messageText = "Vil du gemme ændringerne?"
        alert.informativeText = "Du har ændret listen af brugere."
        alert.addButton(withTitle: "Gem og Luk")
        alert.addButton(withTitle: "Annuller")
        
        return alert.runModal() == .alertFirstButtonReturn
    }
    
    private func getChosenUser() -> String? {
        return userListMenu.selectedItem?.title
    }
}
