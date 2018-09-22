//
//  RealmTests.swift
//  ActivityTrackerSDUTests
//
//  Created by Kasper Dissing Bargsteen on 17/09/2018.
//

import XCTest
@testable import ActivityTrackerSDU
import RealmSwift
import Realm

class RealmTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNoDeviceOrAppUsagesInTestDb() {
        let retrievedAppUsage = Persistence.maybeFetchOldestAppUsage()
        let retrievedDeviceUsage = Persistence.maybeFetchOldestDeviceUsage()
        
        XCTAssertNil(retrievedAppUsage)
        XCTAssertNil(retrievedDeviceUsage)
    }

    func testCanSaveAndRetrieveDeviceUsage() {
        // Arrange
        let id = "TestId"
        let deviceUsage = makeTestDeviceUsage(id: id, timeStamp: nil)
        // Act
        Persistence.save(deviceUsage)
        let retrievedData = Persistence.maybeFetchOldestDeviceUsage()
        // Assert
        XCTAssertEqual(id,retrievedData?.participantIdentifier)
    }
    
    func testCanSaveAndRetrieveAppUsage() {
        // Arrange
        let id = "TestId"
        let appUsage = makeTestAppUsage(id: id, timeStamp: nil)
        // Act
        Persistence.save(appUsage)
        let retrievedData = Persistence.maybeFetchOldestAppUsage()
        // Assert
        XCTAssertEqual(id,retrievedData?.participantIdentifier)
    }
    
    func testCanDeleteDeviceUsage() {
        // Arrange
        let id = "TestId"
        let deviceUsage = makeTestDeviceUsage(id: id, timeStamp: nil)
        // Act
        Persistence.save(deviceUsage)
        
        Persistence.deleteDeviceUsage(deviceUsage.getIdentifier())
        let retrievedData = Persistence.maybeFetchOldestDeviceUsage()
        
        // Assert
        XCTAssertNil(retrievedData)
    }
    
    func testCanDeleteAppUsage() {
        // Arrange
        let id = "TestId"
        let appUsage = makeTestAppUsage(id: id, timeStamp: nil)
        // Act
        Persistence.save(appUsage)
        Persistence.deleteAppUsage(appUsage.getIdentifier())
        let retrievedData = Persistence.maybeFetchOldestAppUsage()
        // Assert
        XCTAssertNil(retrievedData)
    }
    
    func testRetrievesOldestAppUsage() {
        // Arrange
        let id1 = "IdOLD"
        let id2 = "IdNewer"
        let appUsageOld = makeTestAppUsage(id: id1, timeStamp: Date())
        let appUsageNewer = makeTestAppUsage(id: id2, timeStamp: Date().addingTimeInterval(TimeInterval(exactly: 10000)!))
        
        // Act
        Persistence.save(appUsageNewer)
        Persistence.save(appUsageOld)
        
        let retrievedData = Persistence.maybeFetchOldestAppUsage()
        // Assert
        XCTAssertEqual(id1, retrievedData?.participantIdentifier)
    }
    
    func testRetrievesOldestDeviceUsage() {
        // Arrange
        let id1 = "IdOLD"
        let id2 = "IdNewer"
        let deviceUsageOld = makeTestDeviceUsage(id: id1, timeStamp: Date())
        let deviceUsageNewer = makeTestDeviceUsage(id: id2, timeStamp: Date().addingTimeInterval(TimeInterval(exactly: 10000)!))
        
        // Act
        Persistence.save(deviceUsageNewer)
        Persistence.save(deviceUsageOld)
        
        let retrievedData = Persistence.maybeFetchOldestDeviceUsage()
        // Assert
        XCTAssertEqual(id1, retrievedData?.participantIdentifier)
    }
    
    func makeTestDeviceUsage(id: String, timeStamp: Date?) -> DeviceUsage {
        return DeviceUsage(participantIdentifier: id, eventType: .started, timeStamp: timeStamp ?? Date(), userCount: 1, deviceModelName: "TestDevice")
    }
    
    func makeTestAppUsage(id: String, timeStamp: Date?) -> AppUsage {
        return AppUsage(participantIdentifier: id, timeStamp: timeStamp ?? Date(), userCount: 1, deviceModelName: "TestDevice", package: "TestPackage", duration: 100)
    }

}
