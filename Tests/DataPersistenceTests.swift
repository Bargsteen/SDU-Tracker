//
//  DataPersistenceTests.swift
//  ActivityTrackerSDUTests
//
//  Created by Kasper Dissing Bargsteen on 15/09/2018.
//

import XCTest
@testable import ActivityTrackerSDU

class DataPersistenceTests: XCTestCase {
    var dataPersistence : DataPersistence! = nil
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Storage.clear(Storage.Directory.caches)
        dataPersistence = DataPersistence(directoryToUse: Storage.Directory.caches)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        Storage.clear(Storage.Directory.caches)
        dataPersistence = nil
    }

    func testSaveAndRetrieveDeviceUsage() {
        // Arrange
        let (identifierOne, identifierTwo) = ("usageOneStarted", "usageOneEnded")
        let usageOneStarted = DeviceUsage(participantIdentifier: identifierOne, eventType: .started, timeStamp: Date(), userCount: 1, deviceModelName: "TestModel")
        let usageOneEnded = DeviceUsage(participantIdentifier: identifierTwo, eventType: .ended, timeStamp: Date(), userCount: 1, deviceModelName: "TestModel")
        
        // Act
        dataPersistence.saveDeviceUsage(usageOneStarted)
        dataPersistence.saveDeviceUsage(usageOneEnded)
        
        let retrievedUsages = dataPersistence.retrieveSavedDeviceUsages()
        
        // Assert
        XCTAssertEqual(2, retrievedUsages.count)
        XCTAssertEqual(identifierOne, retrievedUsages[0].participantIdentifier)
        XCTAssertEqual(identifierTwo, retrievedUsages[1].participantIdentifier)
    }

}
