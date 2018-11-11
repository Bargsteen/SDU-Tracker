//
//  PersistenceHandlerTests.swift
//  ActivityTrackerSDUTests
//
//  Created by Kasper Dissing Bargsteen on 11/11/2018.
//

import XCTest
import Cuckoo

@testable import ActivityTrackerSDU

class PersistenceHandlerTests: XCTestCase {

    private var persistenceHandler: PersistenceHandler!
    
    override func setUp() {
        super.setUp()
        let loggerStub = LoggerStub()
        
        let mockSettings = MockSettingsProtocol()
        stub(mockSettings) { stub in
            when(stub.deviceModelName.get).thenReturn("testDeviceModel")
        }
        
        persistenceHandler = PersistenceHandler(logger: loggerStub, settings: mockSettings, useInMemoryDb: true)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testNoDeviceOrAppUsagesInTestDb() {
        let retrievedAppUsage = persistenceHandler.fetchAppUsages(upTo: 1).first
        let retrievedDeviceUsage = persistenceHandler.fetchDeviceUsages(upTo: 1).first
        
        XCTAssertNil(retrievedAppUsage)
        XCTAssertNil(retrievedDeviceUsage)
    }

    func testCanSaveAndFetchDeviceUsage() {
        // Arrange
        let participantIdentifier = "TestId"
        let deviceUsage = makeTestDeviceUsage(participantIdentifier: participantIdentifier, timeStamp: nil)
        
        // Act
        persistenceHandler.save(deviceUsage)
        let fetchedDeviceUsage = persistenceHandler.fetchDeviceUsages(upTo: 1).first
        
        // Assert
        XCTAssertEqual(participantIdentifier, fetchedDeviceUsage?.participantIdentifier)
    }
    
    func testCanSaveAndFetchAppUsage() {
        // Arrange
        let participantIdentifier = "TestId"
        let appUsage = makeTestAppUsage(participantIdentifier: participantIdentifier, timeStamp: nil)
        
        // Act
        persistenceHandler?.save(appUsage)
        let fetchedAppUsage = persistenceHandler.fetchAppUsages(upTo: 1).first
        
        // Assert
        XCTAssertEqual(participantIdentifier, fetchedAppUsage?.participantIdentifier)
    }
    
    func testCanDeleteDeviceUsage() {
        // Arrange
        let participantIdentifier = "TestId"
        let deviceUsage = makeTestDeviceUsage(participantIdentifier: participantIdentifier, timeStamp: nil)
        
        // Act
        persistenceHandler.save(deviceUsage)
        let fetchedDeviceUsage = persistenceHandler.fetchDeviceUsages(upTo: 1).first!
        persistenceHandler.delete(fetchedDeviceUsage)
        
        let refetchedDeviceUsage = persistenceHandler.fetchDeviceUsages(upTo: 1).first
        
        // Assert
        XCTAssertNil(refetchedDeviceUsage)
    }
    
    func testCanDeleteAppUsage() {
        // Arrange
        let participantIdentifier = "TestId"
        let appUsage = makeTestAppUsage(participantIdentifier: participantIdentifier, timeStamp: nil)
        
        // Act
        persistenceHandler.save(appUsage)
        let fetchedAppUsage = persistenceHandler.fetchAppUsages(upTo: 1).first!
        persistenceHandler.delete(fetchedAppUsage)
        
        let refetchedAppUsage = persistenceHandler.fetchAppUsages(upTo: 1).first
        
        // Assert
        XCTAssertNil(refetchedAppUsage)
    }
    
    func testFetchesAppUsagesOrderedByDate() {
        // Arrange
        let participantIdentifierOld = "IdOld"
        let participantIdentifierNew = "IdNew"
        let appUsageOld = makeTestAppUsage(participantIdentifier: participantIdentifierOld, timeStamp: Date.distantPast)
        let appUsageNew = makeTestAppUsage(participantIdentifier: participantIdentifierNew, timeStamp: Date.distantFuture)
        
        // Act
        persistenceHandler.save(appUsageNew)
        persistenceHandler.save(appUsageOld)
        
        let fetchedAppUsage = persistenceHandler.fetchAppUsages(upTo:1).first
        
        // Assert
        XCTAssertEqual(participantIdentifierOld, fetchedAppUsage?.participantIdentifier)
    }
    
    func testRetrievesDeviceUsagesOrderedByDate() {
        // Arrange
        let participantIdentifierOld = "IdOld"
        let participantIdentifierNew = "IdNew"
        let deviceUsageOld = makeTestDeviceUsage(participantIdentifier: participantIdentifierOld, timeStamp: Date.distantPast)
        let deviceUsageNew = makeTestDeviceUsage(participantIdentifier: participantIdentifierNew, timeStamp: Date.distantFuture)
        
        // Act
        persistenceHandler.save(deviceUsageNew)
        persistenceHandler.save(deviceUsageOld)
        
        let fetchedDeviceUsage = persistenceHandler.fetchDeviceUsages(upTo: 1).first
        
        // Assert
        XCTAssertEqual(participantIdentifierOld, fetchedDeviceUsage?.participantIdentifier)
    }
    
    func testFetchedAppUsageHasId() {
        // Arrange
        let participantIdentifier = "testParticipantId"
        let appUsage = makeTestAppUsage(participantIdentifier: participantIdentifier, timeStamp: nil)
        
        // Act
        persistenceHandler.save(appUsage)
        
        let fetchedAppUsage = persistenceHandler.fetchAppUsages(upTo: 1).first
        
        // Assert
        XCTAssertEqual(participantIdentifier, fetchedAppUsage?.participantIdentifier)
        XCTAssertNotNil(fetchedAppUsage?.id)
    }
    
    func testFetchedDeviceUsageHasId() {
        // Arrange
        let participantIdentifier = "testParticipantId"
        let deviceUsage = makeTestDeviceUsage(participantIdentifier: participantIdentifier, timeStamp: nil)
        
        // Act
        persistenceHandler.save(deviceUsage)
        
        let fetchedDeviceUsage = persistenceHandler.fetchDeviceUsages(upTo: 1).first
        
        // Assert
        XCTAssertEqual(participantIdentifier, fetchedDeviceUsage?.participantIdentifier)
        XCTAssertNotNil(fetchedDeviceUsage?.id)
    }
    
    private func makeTestDeviceUsage(participantIdentifier: String, timeStamp: Date?) -> DeviceUsage {
        return DeviceUsage(participantIdentifier: participantIdentifier, deviceModelName: "TestDevice", timeStamp: timeStamp ?? Date(), userCount: 1, eventType: .started)
    }
    
    private func makeTestAppUsage(participantIdentifier: String, timeStamp: Date?) -> AppUsage {
        return AppUsage(participantIdentifier: participantIdentifier, deviceModelName: "TestDevice", timeStamp: timeStamp ?? Date(), userCount: 1, package: "TestPackage", duration: 100)
    }

}

