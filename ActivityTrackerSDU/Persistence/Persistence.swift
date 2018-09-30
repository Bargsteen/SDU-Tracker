//
//  RealmPersistence.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 16/09/2018.
//

import Foundation
import Realm
import RealmSwift


class Persistence {
    static func save<T:Usage>(_ usage: T){
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(usage.managedObject())
            }
        } catch {
            Logging.logError("Persistence save: \(error)")
        }
    }
    
    static func delete<T: Usage>(_ usage: T){
        do {
            let realm = try Realm()
            let objectToDelete = realm.object(ofType: type(of: usage.managedObject()), forPrimaryKey: usage.getIdentifier())
            if let objectToDelete = objectToDelete {
                try realm.write {
                    realm.delete(objectToDelete)
                }
            }
        } catch {
            Logging.logError("Persistence delete: \(error)")
        }
    }
    
    static func fetchDeviceUsages(upTo: Int) -> [DeviceUsage] {
        do {
            let realm = try Realm()
            return realm.objects(DeviceUsageObject.self)
                .sorted(byKeyPath: "timeStamp", ascending: true)
                .prefix(upTo) // return first upTo elements. Bound safe.
                .map { obj in DeviceUsage(managedObject: obj) }
        } catch {
            Logging.logError("Persistence fetchAllDeviceUsages: \(error)")
        }
        return []
    }
    
    static func fetchAppUsages(upTo: Int) -> [AppUsage] {
        do {
            let realm = try Realm()
            return realm.objects(AppUsageObject.self)
                .sorted(byKeyPath: "timeStamp", ascending: true)
                .prefix(upTo) // return first upTo elements. Bound safe.
                .map { obj in AppUsage(managedObject: obj) }
        } catch {
            Logging.logError("Persistence fetchAllAppUsages: \(error)")
        }
        return []
    }

}
