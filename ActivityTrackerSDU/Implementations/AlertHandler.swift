//
//  AlertHandler.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 04/11/2018.
//

import Foundation
import Cocoa

class AlertHandler: AlertHandlerProtocol {
    private let dateTimeHandler: DateTimeHandlerProtocol
    
    private var lastAlertTimeStamp: Date?
    
    init(dateTimeHandler: DateTimeHandlerProtocol) {
        self.dateTimeHandler = dateTimeHandler
    }
    
    func promptForUserChange(currentUser: String) -> Bool {
        let now = dateTimeHandler.now
        
        // Don't show this prompt just after another one
        if let lastAlertTimeStamp = lastAlertTimeStamp {
            let timeSinceLastAlert = now.timeIntervalSince(lastAlertTimeStamp)
            if timeSinceLastAlert.toMilliseconds() < 5000 {
                return false
            }
        }
        
        let alert = NSAlert()
        alert.messageText = "Er du \(currentUser)?"
        alert.informativeText = "Hvis ikke, så skift nuværende bruger."
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Ja, det er mig")
        alert.addButton(withTitle: "Nej, skift bruger")
                
        var shouldShowChooseUserWindow = false
                
        // Stops the modal after changeUserAlertTimeDisplayed seconds and returns false, i.e. do not change the user.
        hideAlertAfter(seconds: .alertShowTime)
                
        // Show the modal and wait up to x seconds for a click.
        shouldShowChooseUserWindow = alert.runModal() == .alertSecondButtonReturn
                
        lastAlertTimeStamp = dateTimeHandler.now
                
        return shouldShowChooseUserWindow
    }
    
    func showTrackingPeriodHasEndedAlert(){
        let alert = NSAlert()
        alert.messageText = "Tracking perioden er afsluttet"
        alert.informativeText = "Tak for din deltagelse."
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Ok")
        
        hideAlertAfter(seconds: .alertShowTime)
        
        alert.runModal()
    }
    
    func showApplicationReadyForSetupLinkAlert() {
        let alert = NSAlert()
        alert.messageText = "Klar til opsætning"
        alert.informativeText = "ActivityTrackerSDU er installeret, men mangler at blive sat op via. linket, som du har modtaget på e-mail."
        alert.addButton(withTitle: "Ok")
        
        hideAlertAfter(seconds: .alertShowTimeLong)
        
        alert.runModal()
    }
    
    private func hideAlertAfter(seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            NSApplication.shared.stopModal()
        }
    }
}
