//
//  CredentialsWindow.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 31/08/2018.
//

import Cocoa

class CredentialsWindow: NSWindowController, NSWindowDelegate {

    @IBOutlet weak var userNameTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    
    var credentialsAreSaved = false
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    override var windowNibName: NSNib.Name? {
        return NSNib.Name("CredentialsWindow")
    }
    
    @IBAction func saveButtonClicked(_ sender: NSButton) {
        if(userNameTextField.stringValue != "" && passwordTextField.stringValue != "") {
            do {
                let credentials = Credentials(username: userNameTextField.stringValue, password: passwordTextField.stringValue)
                try CredentialsHandler.saveCredentialsToKeychain(credentials: credentials)
                showAlertWithSingleButton(messageText: "Succesful gemning", informativeText: "Brugeren \(credentials.username) blev succesfuldt gemt.", buttonText: "Okay", alertStyle: .informational)
                credentialsAreSaved = true
                
                // Clean up text fields
                userNameTextField.stringValue = ""
                passwordTextField.stringValue = ""
                
                self.window?.close()
            } catch {
                Logging.logError("Could not save credentials. \(error)")
                showAlertWithSingleButton(messageText: "Der skete en fejl ved gemning", informativeText: "Fejlmeddelelse: \(error)", buttonText: "Okay", alertStyle: .critical)
            }
        }
    }
    
    func showAlertWithSingleButton(messageText: String, informativeText: String, buttonText: String, alertStyle: NSAlert.Style) {
        let alert = NSAlert()
        alert.messageText = messageText
        alert.informativeText = informativeText
        alert.alertStyle = alertStyle
        alert.addButton(withTitle: buttonText)
        alert.runModal()
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        return credentialsAreSaved
    }
}
