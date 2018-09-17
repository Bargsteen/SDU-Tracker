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
    static let sharedInstance = Persistence()
    
    static func save<T:Persistable>(_ data: T){
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(data.managedObject())
            }
        } catch {
            // TODO: Log error
            print("error saving: \(error)")
        }
        
    }
    
    static func maybeRetrieveOldestDeviceUsage() -> DeviceUsage? {
        do {
            let realm = try Realm()
            if let retrievedObject = realm.objects(DeviceUsageObject.self).sorted(byKeyPath: "timeStamp").first {
                return DeviceUsage(managedObject: retrievedObject)
            }
            
        } catch {
            // TODO: Log error
            print("Error on retrieving old devices usages: \(error)")
        }
       return nil
    }
    
    static func maybeRetrieveOldestAppUsage() -> AppUsage? {
        
        do {
            let realm = try Realm()
            if let retrievedObject = realm.objects(AppUsageObject.self).sorted(byKeyPath: "timeStamp").first {
                return AppUsage(managedObject: retrievedObject)
            }
            
        } catch {
            // TODO: Log error
            print("Error on retrieving old app usages: \(error)")
        }
        return nil
    }
    
    static func deleteDeviceUsage(_ identifier: String) {
        do {
            let realm = try Realm()
            let objectToDelete = realm.object(ofType: DeviceUsageObject.self, forPrimaryKey: identifier)
            if let objectToDelete = objectToDelete {
                try realm.write {
                    realm.delete(objectToDelete)
                }
            }
            
        } catch {
            // TODO: Log error
            print("Realm delete error. Identifier:\(identifier). Error: \(error)")
        }
    }
    
    static func deleteAppUsage(_ identifier: String) {
        do {
            let realm = try Realm()
            let objectToDelete = realm.object(ofType: AppUsageObject.self, forPrimaryKey: identifier)
            if let objectToDelete = objectToDelete {
                try realm.write {
                    realm.delete(objectToDelete)
                }
            }
            
        } catch {
            // TODO: Log error
            print("Realm delete error. Identifier:\(identifier). Error: \(error)")
        }
    }
}
