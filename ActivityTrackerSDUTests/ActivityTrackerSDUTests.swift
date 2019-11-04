//
//  ActivityTrackerSDUTests.swift
//  ActivityTrackerSDUTests
//
//  Created by Kasper Dissing Bargsteen on 08/11/2018.
//
/*
import XCTest
import Cuckoo

@testable import ActivityTrackerSDU

class ActivityTrackerSDUTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMockingWorks() {
        let testUser = "test-user"
        let changedTestUser = "changed-test-user"
        let mockSettings = MockSettingsProtocol()
        
        stub(mockSettings) { stub in
            when(stub.currentUser.get).thenReturn(testUser)
            when(stub.currentUser.set(anyString())).then {
                when(stub.currentUser.get).thenReturn($0)
            }
        }
        
        mockSettings.currentUser = changedTestUser
        
        XCTAssertEqual(changedTestUser, mockSettings.currentUser)
    }
}
*/
