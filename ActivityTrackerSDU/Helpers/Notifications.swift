//
//  Notifications.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 22/09/2018.
//

import Foundation

func showNotification(title: String, informativeText: String) {
    let notification = NSUserNotification()
    notification.title = title
    notification.informativeText = informativeText
    notification.soundName = NSUserNotificationDefaultSoundName
    NSUserNotificationCenter.default.deliver(notification)
}

func maybeShowSentSavedNotification(shouldShow: Bool, usageType: UsageType, notificationType: NotificationType, usageDescription: String){
    if(shouldShow){
        let title = usageType.rawValue + notificationType.rawValue
        showNotification(title: title, informativeText: usageDescription)
        print("\(title) \(usageDescription)")
    }
}

enum NotificationType: String {
    case sent = "sendt: "
    case saved = "gemt: "
}
