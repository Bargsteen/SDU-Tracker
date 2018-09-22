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
    
    static func maybeFetchOldestDeviceUsage() -> DeviceUsage? {
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
    
    static func maybeFetchOldestAppUsage() -> AppUsage? {
        
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
    
    static func fetchAllAppUsages() -> [AppUsage] {
        do {
            let realm = try Realm()
            return realm.objects(AppUsageObject.self).map { obj in AppUsage(managedObject: obj) }
        } catch {
            // TODO: Log error
            print("Error on retrieving old app usages: \(error)")
        }
        return []
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
    
    /*static func fetchAppUsageById(_ identifier: String) -> AppUsage? {
        do {
            let realm = try Realm()
            let objectFromDb = realm.object(ofType: AppUsageObject.self, forPrimaryKey: identifier)
            if let objectFromDb = objectFromDb {
                let appUsageFound = AppUsage(managedObject: objectFromDb)
                if(appUsageFound.getIdentifier() != identifier) {
                    fatalError("Retrieved some other object or none..")
                }
                return appUsageFound
            } else {
                fatalError("object retrieved from DB was nil")
            }
            
            
        } catch {
            print("Could not retrieve appUsage with id: \(identifier)")
        }
        return nil
    }*/
    
    static func deleteAppUsage(_ identifier: String) {
        do {
            let realm = try Realm()
            let objectToDelete = realm.object(ofType: AppUsageObject.self, forPrimaryKey: identifier)
            
            if let objectToDelete = objectToDelete {
                print(objectToDelete)
                
                try realm.write {
                    realm.delete(objectToDelete)
                }
            } else {
                print("Could not find object with identifier: \(identifier)")
            }
            
        } catch {
            // TODO: Log error
            print("Realm delete error. Identifier:\(identifier). Error: \(error)")
        }
    }
}
