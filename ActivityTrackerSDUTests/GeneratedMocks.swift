// MARK: - Mocks generated from file: ActivityTrackerSDU/Protocols/DeviceTrackerProtocol.swift at 2018-11-11 17:45:53 +0000

//
//  DeviceTrackerProtocol.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 04/11/2018.
//
/*
import Cuckoo
@testable import ActivityTrackerSDU

import Foundation

class MockDeviceTrackerProtocol: DeviceTrackerProtocol, Cuckoo.ProtocolMock {
    typealias MocksType = DeviceTrackerProtocol
    typealias Stubbing = __StubbingProxy_DeviceTrackerProtocol
    typealias Verification = __VerificationProxy_DeviceTrackerProtocol

    private var __defaultImplStub: DeviceTrackerProtocol?

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    func enableDefaultImplementation(_ stub: DeviceTrackerProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    

    

    
    // ["name": "startTracking", "returnSignature": "", "fullyQualifiedName": "startTracking()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "escapingParameterNames": "", "stubFunction": "Cuckoo.ProtocolStubNoReturnFunction"]
     func startTracking()  {
        
            return cuckoo_manager.call("startTracking()",
                parameters: (),
                escapingParameters: (),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.startTracking())
        
    }
    
    // ["name": "stopTracking", "returnSignature": "", "fullyQualifiedName": "stopTracking()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "escapingParameterNames": "", "stubFunction": "Cuckoo.ProtocolStubNoReturnFunction"]
     func stopTracking()  {
        
            return cuckoo_manager.call("stopTracking()",
                parameters: (),
                escapingParameters: (),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.stopTracking())
        
    }
    

	struct __StubbingProxy_DeviceTrackerProtocol: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func startTracking() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockDeviceTrackerProtocol.self, method: "startTracking()", parameterMatchers: matchers))
	    }
	    
	    func stopTracking() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockDeviceTrackerProtocol.self, method: "stopTracking()", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_DeviceTrackerProtocol: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func startTracking() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("startTracking()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func stopTracking() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("stopTracking()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class DeviceTrackerProtocolStub: DeviceTrackerProtocol {
    

    

    
     func startTracking()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func stopTracking()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}


// MARK: - Mocks generated from file: ActivityTrackerSDU/Protocols/SettingsProtocol.swift at 2018-11-11 17:45:53 +0000

//
//  SettingsProtocol.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 04/11/2018.
//

import Cuckoo
@testable import ActivityTrackerSDU

import Foundation

class MockSettingsProtocol: SettingsProtocol, Cuckoo.ProtocolMock {
    typealias MocksType = SettingsProtocol
    typealias Stubbing = __StubbingProxy_SettingsProtocol
    typealias Verification = __VerificationProxy_SettingsProtocol

    private var __defaultImplStub: SettingsProtocol?

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    func enableDefaultImplementation(_ stub: SettingsProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    
    
     var appHasBeenSetup: Bool {
        get {
            return cuckoo_manager.getter("appHasBeenSetup",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.appHasBeenSetup)
        }
        
        set {
            cuckoo_manager.setter("appHasBeenSetup",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.appHasBeenSetup = newValue)
        }
        
    }
    
    
     var userList: [String] {
        get {
            return cuckoo_manager.getter("userList",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.userList)
        }
        
        set {
            cuckoo_manager.setter("userList",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.userList = newValue)
        }
        
    }
    
    
     var userCount: Int {
        get {
            return cuckoo_manager.getter("userCount",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.userCount)
        }
        
    }
    
    
     var currentUser: String {
        get {
            return cuckoo_manager.getter("currentUser",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentUser)
        }
        
        set {
            cuckoo_manager.setter("currentUser",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.currentUser = newValue)
        }
        
    }
    
    
     var deviceModelName: String {
        get {
            return cuckoo_manager.getter("deviceModelName",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.deviceModelName)
        }
        
    }
    
    
     var trackingType: TrackingType {
        get {
            return cuckoo_manager.getter("trackingType",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.trackingType)
        }
        
        set {
            cuckoo_manager.setter("trackingType",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.trackingType = newValue)
        }
        
    }
    
    
     var stopTrackingDate: Date {
        get {
            return cuckoo_manager.getter("stopTrackingDate",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.stopTrackingDate)
        }
        
        set {
            cuckoo_manager.setter("stopTrackingDate",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.stopTrackingDate = newValue)
        }
        
    }
    
    
     var userId: String {
        get {
            return cuckoo_manager.getter("userId",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.userId)
        }
        
        set {
            cuckoo_manager.setter("userId",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.userId = newValue)
        }
        
    }
    
    
     var participantIdentifier: String {
        get {
            return cuckoo_manager.getter("participantIdentifier",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.participantIdentifier)
        }
        
    }
    
    
     var credentials: Credentials {
        get {
            return cuckoo_manager.getter("credentials",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.credentials)
        }
        
    }
    

    

    
    // ["name": "subscribeToUserChanges", "returnSignature": "", "fullyQualifiedName": "subscribeToUserChanges(_: UserChangedDelegate)", "parameterSignature": "_ newListener: UserChangedDelegate", "parameterSignatureWithoutNames": "newListener: UserChangedDelegate", "inputTypes": "UserChangedDelegate", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "newListener", "call": "newListener", "parameters": [CuckooGeneratorFramework.MethodParameter(label: nil, name: "newListener", type: "UserChangedDelegate", range: CountableRange(356..<390), nameRange: CountableRange(0..<0))], "returnType": "Void", "isOptional": false, "escapingParameterNames": "newListener", "stubFunction": "Cuckoo.ProtocolStubNoReturnFunction"]
     func subscribeToUserChanges(_ newListener: UserChangedDelegate)  {
        
            return cuckoo_manager.call("subscribeToUserChanges(_: UserChangedDelegate)",
                parameters: (newListener),
                escapingParameters: (newListener),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.subscribeToUserChanges(newListener))
        
    }
    
    // ["name": "makeParticipantIdentifierForSpecificUser", "returnSignature": " -> String", "fullyQualifiedName": "makeParticipantIdentifierForSpecificUser(user: String) -> String", "parameterSignature": "user: String", "parameterSignatureWithoutNames": "user: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "user", "call": "user: user", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("user"), name: "user", type: "String", range: CountableRange(677..<689), nameRange: CountableRange(677..<681))], "returnType": "String", "isOptional": false, "escapingParameterNames": "user", "stubFunction": "Cuckoo.ProtocolStubFunction"]
     func makeParticipantIdentifierForSpecificUser(user: String)  -> String {
        
            return cuckoo_manager.call("makeParticipantIdentifierForSpecificUser(user: String) -> String",
                parameters: (user),
                escapingParameters: (user),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.makeParticipantIdentifierForSpecificUser(user: user))
        
    }
    

	struct __StubbingProxy_SettingsProtocol: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var appHasBeenSetup: Cuckoo.ProtocolToBeStubbedProperty<MockSettingsProtocol, Bool> {
	        return .init(manager: cuckoo_manager, name: "appHasBeenSetup")
	    }
	    
	    var userList: Cuckoo.ProtocolToBeStubbedProperty<MockSettingsProtocol, [String]> {
	        return .init(manager: cuckoo_manager, name: "userList")
	    }
	    
	    var userCount: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockSettingsProtocol, Int> {
	        return .init(manager: cuckoo_manager, name: "userCount")
	    }
	    
	    var currentUser: Cuckoo.ProtocolToBeStubbedProperty<MockSettingsProtocol, String> {
	        return .init(manager: cuckoo_manager, name: "currentUser")
	    }
	    
	    var deviceModelName: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockSettingsProtocol, String> {
	        return .init(manager: cuckoo_manager, name: "deviceModelName")
	    }
	    
	    var trackingType: Cuckoo.ProtocolToBeStubbedProperty<MockSettingsProtocol, TrackingType> {
	        return .init(manager: cuckoo_manager, name: "trackingType")
	    }
	    
	    var stopTrackingDate: Cuckoo.ProtocolToBeStubbedProperty<MockSettingsProtocol, Date> {
	        return .init(manager: cuckoo_manager, name: "stopTrackingDate")
	    }
	    
	    var userId: Cuckoo.ProtocolToBeStubbedProperty<MockSettingsProtocol, String> {
	        return .init(manager: cuckoo_manager, name: "userId")
	    }
	    
	    var participantIdentifier: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockSettingsProtocol, String> {
	        return .init(manager: cuckoo_manager, name: "participantIdentifier")
	    }
	    
	    var credentials: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockSettingsProtocol, Credentials> {
	        return .init(manager: cuckoo_manager, name: "credentials")
	    }
	    
	    
	    func subscribeToUserChanges<M1: Cuckoo.Matchable>(_ newListener: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(UserChangedDelegate)> where M1.MatchedType == UserChangedDelegate {
	        let matchers: [Cuckoo.ParameterMatcher<(UserChangedDelegate)>] = [wrap(matchable: newListener) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockSettingsProtocol.self, method: "subscribeToUserChanges(_: UserChangedDelegate)", parameterMatchers: matchers))
	    }
	    
	    func makeParticipantIdentifierForSpecificUser<M1: Cuckoo.Matchable>(user: M1) -> Cuckoo.ProtocolStubFunction<(String), String> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: user) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockSettingsProtocol.self, method: "makeParticipantIdentifierForSpecificUser(user: String) -> String", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_SettingsProtocol: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    var appHasBeenSetup: Cuckoo.VerifyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "appHasBeenSetup", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var userList: Cuckoo.VerifyProperty<[String]> {
	        return .init(manager: cuckoo_manager, name: "userList", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var userCount: Cuckoo.VerifyReadOnlyProperty<Int> {
	        return .init(manager: cuckoo_manager, name: "userCount", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var currentUser: Cuckoo.VerifyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "currentUser", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var deviceModelName: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "deviceModelName", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var trackingType: Cuckoo.VerifyProperty<TrackingType> {
	        return .init(manager: cuckoo_manager, name: "trackingType", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var stopTrackingDate: Cuckoo.VerifyProperty<Date> {
	        return .init(manager: cuckoo_manager, name: "stopTrackingDate", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var userId: Cuckoo.VerifyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "userId", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var participantIdentifier: Cuckoo.VerifyReadOnlyProperty<String> {
	        return .init(manager: cuckoo_manager, name: "participantIdentifier", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	    var credentials: Cuckoo.VerifyReadOnlyProperty<Credentials> {
	        return .init(manager: cuckoo_manager, name: "credentials", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func subscribeToUserChanges<M1: Cuckoo.Matchable>(_ newListener: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == UserChangedDelegate {
	        let matchers: [Cuckoo.ParameterMatcher<(UserChangedDelegate)>] = [wrap(matchable: newListener) { $0 }]
	        return cuckoo_manager.verify("subscribeToUserChanges(_: UserChangedDelegate)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func makeParticipantIdentifierForSpecificUser<M1: Cuckoo.Matchable>(user: M1) -> Cuckoo.__DoNotUse<String> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: user) { $0 }]
	        return cuckoo_manager.verify("makeParticipantIdentifierForSpecificUser(user: String) -> String", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class SettingsProtocolStub: SettingsProtocol {
    
     var appHasBeenSetup: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
        set { }
        
    }
    
     var userList: [String] {
        get {
            return DefaultValueRegistry.defaultValue(for: ([String]).self)
        }
        
        set { }
        
    }
    
     var userCount: Int {
        get {
            return DefaultValueRegistry.defaultValue(for: (Int).self)
        }
        
    }
    
     var currentUser: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
        set { }
        
    }
    
     var deviceModelName: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
     var trackingType: TrackingType {
        get {
            return DefaultValueRegistry.defaultValue(for: (TrackingType).self)
        }
        
        set { }
        
    }
    
     var stopTrackingDate: Date {
        get {
            return DefaultValueRegistry.defaultValue(for: (Date).self)
        }
        
        set { }
        
    }
    
     var userId: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
        set { }
        
    }
    
     var participantIdentifier: String {
        get {
            return DefaultValueRegistry.defaultValue(for: (String).self)
        }
        
    }
    
     var credentials: Credentials {
        get {
            return DefaultValueRegistry.defaultValue(for: (Credentials).self)
        }
        
    }
    

    

    
     func subscribeToUserChanges(_ newListener: UserChangedDelegate)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func makeParticipantIdentifierForSpecificUser(user: String)  -> String {
        return DefaultValueRegistry.defaultValue(for: String.self)
    }
    
}


// MARK: - Mocks generated from file: ActivityTrackerSDU/Protocols/TrackerProtocol.swift at 2018-11-11 17:45:53 +0000

//
//  TrackerProtocol.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 04/11/2018.
//

import Cuckoo
@testable import ActivityTrackerSDU

import Foundation

class MockTrackerProtocol: TrackerProtocol, Cuckoo.ProtocolMock {
    typealias MocksType = TrackerProtocol
    typealias Stubbing = __StubbingProxy_TrackerProtocol
    typealias Verification = __VerificationProxy_TrackerProtocol

    private var __defaultImplStub: TrackerProtocol?

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    func enableDefaultImplementation(_ stub: TrackerProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    

    

    
    // ["name": "startTracking", "returnSignature": "", "fullyQualifiedName": "startTracking()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "escapingParameterNames": "", "stubFunction": "Cuckoo.ProtocolStubNoReturnFunction"]
     func startTracking()  {
        
            return cuckoo_manager.call("startTracking()",
                parameters: (),
                escapingParameters: (),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.startTracking())
        
    }
    
    // ["name": "stopTracking", "returnSignature": "", "fullyQualifiedName": "stopTracking()", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "Void", "isOptional": false, "escapingParameterNames": "", "stubFunction": "Cuckoo.ProtocolStubNoReturnFunction"]
     func stopTracking()  {
        
            return cuckoo_manager.call("stopTracking()",
                parameters: (),
                escapingParameters: (),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.stopTracking())
        
    }
    

	struct __StubbingProxy_TrackerProtocol: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func startTracking() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockTrackerProtocol.self, method: "startTracking()", parameterMatchers: matchers))
	    }
	    
	    func stopTracking() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockTrackerProtocol.self, method: "stopTracking()", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_TrackerProtocol: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func startTracking() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("startTracking()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func stopTracking() -> Cuckoo.__DoNotUse<Void> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("stopTracking()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class TrackerProtocolStub: TrackerProtocol {
    

    

    
     func startTracking()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func stopTracking()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}

*/
