//
//  NewUserWindow.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 11/11/2018.
//

import Cocoa

class CreateUserWindow: NSWindowController, NSWindowDelegate {

    @IBOutlet weak var newUserTextField: NSTextField!
    
    var userCreatedDelegate: UserCreatedDelegate?
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        
        self.window?.title = "Opret en ny bruger"
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name("CreateUserWindow")
    }
    
    @IBAction func createButtonClicked(_ sender: NSButton) {
        let newUser = newUserTextField.stringValue
        if(!newUser.isEmpty) {
            userCreatedDelegate?.userCreated(newUser: newUser)
            newUserTextField.stringValue = ""
            self.close()
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: NSButton) {
        self.close()
    }
    
    func show() {
        self.showWindow(nil)
    }
}
