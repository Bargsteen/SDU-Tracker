//
//  RealmModel.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 16/09/2018.
//

import Foundation
import RealmSwift

final class DeviceUsageObject: Object {
    @objc dynamic var identifier = ""
    @objc dynamic var participantIdentifier = ""
    @objc dynamic var eventType = 0
    @objc dynamic var timeStamp = ""
    @objc dynamic var userCount = 1
    @objc dynamic var deviceModelName = ""
    override static func primaryKey() -> String? {
        return "identifier"
    }
}

final class AppUsageObject: Object {
    @objc dynamic var identifier = ""
    @objc dynamic var participantIdentifier = ""
    @objc dynamic var timeStamp = ""
    @objc dynamic var userCount = 1
    @objc dynamic var deviceModelName = ""
    @objc dynamic var package = ""
    @objc dynamic var duration = 0
    override static func primaryKey() -> String? {
        return "identifier"
    }
}

public protocol Persistable {
    associatedtype ManagedObject: Object
    init(managedObject: ManagedObject)
    func managedObject() -> ManagedObject
}


extension DeviceUsage: Persistable {
    public init(managedObject: DeviceUsageObject) {
        participantIdentifier = managedObject.participantIdentifier
        eventType = managedObject.eventType
        timeStamp = managedObject.timeStamp.description
        userCount = managedObject.userCount
        deviceModelName = managedObject.deviceModelName
    }
    
    public func managedObject() -> DeviceUsageObject {
        let object = DeviceUsageObject()
        object.identifier = getIdentifier()
        object.participantIdentifier = participantIdentifier
        object.eventType = eventType
        object.timeStamp = timeStamp
        object.userCount = userCount
        object.deviceModelName = deviceModelName
        return object
    }
}

extension AppUsage: Persistable {
    public init(managedObject: AppUsageObject) {
        participantIdentifier = managedObject.participantIdentifier
        timeStamp = managedObject.timeStamp.description
        userCount = managedObject.userCount
        deviceModelName = managedObject.deviceModelName
        package = managedObject.package
        duration = UInt(managedObject.duration)
    }
    
    public func managedObject() -> AppUsageObject {
        let object = AppUsageObject()
        object.identifier = getIdentifier()
        object.participantIdentifier = participantIdentifier
        object.timeStamp = timeStamp
        object.userCount = userCount
        object.deviceModelName = deviceModelName
        object.package = package
        object.duration = Int(duration)
        return object
    }
}


