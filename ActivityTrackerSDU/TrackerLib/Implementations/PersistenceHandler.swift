//
//  PersistenceHandler.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 16/09/2018.
//

import Foundation
import Realm
import RealmSwift


class PersistenceHandler: PersistenceHandlerProtocol {
    private let logger: LoggerProtocol
    
    init(assembler: AssemblerProtocol) {
        self.logger = assembler.resolve()
    }
    
    func save<T:Usage>(_ usage: T){
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(usage)
            }
        } catch {
            logger.logError("Persistence save: \(error)")
        }
    }
    
    func delete<T: Usage>(_ usage: T){
        do {
            let realm = try Realm()
            let objectToDelete = realm.object(ofType: type(of: usage), forPrimaryKey: usage.identifier)
            if let objectToDelete = objectToDelete {
                try realm.write {
                    realm.delete(objectToDelete)
                }
            }
        } catch {
            logger.logError("Persistence delete: \(error)")
        }
    }
    
    func fetchDeviceUsages() -> Results<DeviceUsage>? {
        do {
            let realm = try Realm()
            return realm.objects(DeviceUsage.self).sorted(byKeyPath: "timeStamp", ascending: true)
        } catch {
            logger.logError("Persistence fetchAllDeviceUsages: \(error)")
        }
        return nil
    }
    
    func fetchAppUsages() -> Results<AppUsage>? {
        do {
            let realm = try Realm()
            return realm.objects(AppUsage.self).sorted(byKeyPath: "timeStamp", ascending: true)
        } catch {
            logger.logError("Persistence fetchAllAppUsages: \(error)")
        }
        return nil
    }

}
