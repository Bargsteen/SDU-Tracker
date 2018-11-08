// MARK: - Mocks generated from file: ActivityTrackerSDU/TrackerLib/AppAssembling/AssemblerProtocol.swift at 2018-11-08 11:36:37 +0000

//
//  AssemblerProtocol.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 06/11/2018.
//
/*
import Cuckoo
@testable import ActivityTrackerSDU

import Foundation

class MockAssemblerProtocol: AssemblerProtocol, Cuckoo.ProtocolMock {
    typealias MocksType = AssemblerProtocol
    typealias Stubbing = __StubbingProxy_AssemblerProtocol
    typealias Verification = __VerificationProxy_AssemblerProtocol

    private var __defaultImplStub: AssemblerProtocol?

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    func enableDefaultImplementation(_ stub: AssemblerProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    

    

    
    // ["name": "resolve", "returnSignature": " -> LoggerProtocol", "fullyQualifiedName": "resolve() -> LoggerProtocol", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "LoggerProtocol", "isOptional": false, "escapingParameterNames": "", "stubFunction": "Cuckoo.ProtocolStubFunction"]
     func resolve()  -> LoggerProtocol {
        
            return cuckoo_manager.call("resolve() -> LoggerProtocol",
                parameters: (),
                escapingParameters: (),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.resolve())
        
    }
    
    // ["name": "resolve", "returnSignature": " -> ActiveWindowHandlerProtocol", "fullyQualifiedName": "resolve() -> ActiveWindowHandlerProtocol", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "ActiveWindowHandlerProtocol", "isOptional": false, "escapingParameterNames": "", "stubFunction": "Cuckoo.ProtocolStubFunction"]
     func resolve()  -> ActiveWindowHandlerProtocol {
        
            return cuckoo_manager.call("resolve() -> ActiveWindowHandlerProtocol",
                parameters: (),
                escapingParameters: (),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.resolve())
        
    }
    
    // ["name": "resolve", "returnSignature": " -> SettingsProtocol", "fullyQualifiedName": "resolve() -> SettingsProtocol", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "SettingsProtocol", "isOptional": false, "escapingParameterNames": "", "stubFunction": "Cuckoo.ProtocolStubFunction"]
     func resolve()  -> SettingsProtocol {
        
            return cuckoo_manager.call("resolve() -> SettingsProtocol",
                parameters: (),
                escapingParameters: (),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.resolve())
        
    }
    
    // ["name": "resolve", "returnSignature": " -> AppTrackerProtocol", "fullyQualifiedName": "resolve() -> AppTrackerProtocol", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "AppTrackerProtocol", "isOptional": false, "escapingParameterNames": "", "stubFunction": "Cuckoo.ProtocolStubFunction"]
     func resolve()  -> AppTrackerProtocol {
        
            return cuckoo_manager.call("resolve() -> AppTrackerProtocol",
                parameters: (),
                escapingParameters: (),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.resolve())
        
    }
    
    // ["name": "resolve", "returnSignature": " -> DeviceTrackerProtocol", "fullyQualifiedName": "resolve() -> DeviceTrackerProtocol", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "DeviceTrackerProtocol", "isOptional": false, "escapingParameterNames": "", "stubFunction": "Cuckoo.ProtocolStubFunction"]
     func resolve()  -> DeviceTrackerProtocol {
        
            return cuckoo_manager.call("resolve() -> DeviceTrackerProtocol",
                parameters: (),
                escapingParameters: (),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.resolve())
        
    }
    
    // ["name": "resolve", "returnSignature": " -> PersistenceHandlerProtocol", "fullyQualifiedName": "resolve() -> PersistenceHandlerProtocol", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "PersistenceHandlerProtocol", "isOptional": false, "escapingParameterNames": "", "stubFunction": "Cuckoo.ProtocolStubFunction"]
     func resolve()  -> PersistenceHandlerProtocol {
        
            return cuckoo_manager.call("resolve() -> PersistenceHandlerProtocol",
                parameters: (),
                escapingParameters: (),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.resolve())
        
    }
    
    // ["name": "resolve", "returnSignature": " -> RequestHandlerProtocol", "fullyQualifiedName": "resolve() -> RequestHandlerProtocol", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "RequestHandlerProtocol", "isOptional": false, "escapingParameterNames": "", "stubFunction": "Cuckoo.ProtocolStubFunction"]
     func resolve()  -> RequestHandlerProtocol {
        
            return cuckoo_manager.call("resolve() -> RequestHandlerProtocol",
                parameters: (),
                escapingParameters: (),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.resolve())
        
    }
    
    // ["name": "resolve", "returnSignature": " -> SendOrSaveHandlerProtocol", "fullyQualifiedName": "resolve() -> SendOrSaveHandlerProtocol", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "SendOrSaveHandlerProtocol", "isOptional": false, "escapingParameterNames": "", "stubFunction": "Cuckoo.ProtocolStubFunction"]
     func resolve()  -> SendOrSaveHandlerProtocol {
        
            return cuckoo_manager.call("resolve() -> SendOrSaveHandlerProtocol",
                parameters: (),
                escapingParameters: (),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.resolve())
        
    }
    
    // ["name": "resolve", "returnSignature": " -> DateTimeHandlerProtocol", "fullyQualifiedName": "resolve() -> DateTimeHandlerProtocol", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "DateTimeHandlerProtocol", "isOptional": false, "escapingParameterNames": "", "stubFunction": "Cuckoo.ProtocolStubFunction"]
     func resolve()  -> DateTimeHandlerProtocol {
        
            return cuckoo_manager.call("resolve() -> DateTimeHandlerProtocol",
                parameters: (),
                escapingParameters: (),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.resolve())
        
    }
    
    // ["name": "resolve", "returnSignature": " -> UserHandlerProtocol", "fullyQualifiedName": "resolve() -> UserHandlerProtocol", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "UserHandlerProtocol", "isOptional": false, "escapingParameterNames": "", "stubFunction": "Cuckoo.ProtocolStubFunction"]
     func resolve()  -> UserHandlerProtocol {
        
            return cuckoo_manager.call("resolve() -> UserHandlerProtocol",
                parameters: (),
                escapingParameters: (),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.resolve())
        
    }
    
    // ["name": "resolve", "returnSignature": " -> AlertHandlerProtocol", "fullyQualifiedName": "resolve() -> AlertHandlerProtocol", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "AlertHandlerProtocol", "isOptional": false, "escapingParameterNames": "", "stubFunction": "Cuckoo.ProtocolStubFunction"]
     func resolve()  -> AlertHandlerProtocol {
        
            return cuckoo_manager.call("resolve() -> AlertHandlerProtocol",
                parameters: (),
                escapingParameters: (),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.resolve())
        
    }
    
    // ["name": "resolve", "returnSignature": " -> ChooseUserWindowProtocol", "fullyQualifiedName": "resolve() -> ChooseUserWindowProtocol", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "ChooseUserWindowProtocol", "isOptional": false, "escapingParameterNames": "", "stubFunction": "Cuckoo.ProtocolStubFunction"]
     func resolve()  -> ChooseUserWindowProtocol {
        
            return cuckoo_manager.call("resolve() -> ChooseUserWindowProtocol",
                parameters: (),
                escapingParameters: (),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.resolve())
        
    }
    
    // ["name": "resolve", "returnSignature": " -> UsageBuilderProtocol", "fullyQualifiedName": "resolve() -> UsageBuilderProtocol", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "UsageBuilderProtocol", "isOptional": false, "escapingParameterNames": "", "stubFunction": "Cuckoo.ProtocolStubFunction"]
     func resolve()  -> UsageBuilderProtocol {
        
            return cuckoo_manager.call("resolve() -> UsageBuilderProtocol",
                parameters: (),
                escapingParameters: (),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.resolve())
        
    }
    
    // ["name": "resolve", "returnSignature": " -> SetupHandlerProtocol", "fullyQualifiedName": "resolve() -> SetupHandlerProtocol", "parameterSignature": "", "parameterSignatureWithoutNames": "", "inputTypes": "", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "", "call": "", "parameters": [], "returnType": "SetupHandlerProtocol", "isOptional": false, "escapingParameterNames": "", "stubFunction": "Cuckoo.ProtocolStubFunction"]
     func resolve()  -> SetupHandlerProtocol {
        
            return cuckoo_manager.call("resolve() -> SetupHandlerProtocol",
                parameters: (),
                escapingParameters: (),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.resolve())
        
    }
    

	struct __StubbingProxy_AssemblerProtocol: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func resolve() -> Cuckoo.ProtocolStubFunction<(), LoggerProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockAssemblerProtocol.self, method: "resolve() -> LoggerProtocol", parameterMatchers: matchers))
	    }
	    
	    func resolve() -> Cuckoo.ProtocolStubFunction<(), ActiveWindowHandlerProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockAssemblerProtocol.self, method: "resolve() -> ActiveWindowHandlerProtocol", parameterMatchers: matchers))
	    }
	    
	    func resolve() -> Cuckoo.ProtocolStubFunction<(), SettingsProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockAssemblerProtocol.self, method: "resolve() -> SettingsProtocol", parameterMatchers: matchers))
	    }
	    
	    func resolve() -> Cuckoo.ProtocolStubFunction<(), AppTrackerProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockAssemblerProtocol.self, method: "resolve() -> AppTrackerProtocol", parameterMatchers: matchers))
	    }
	    
	    func resolve() -> Cuckoo.ProtocolStubFunction<(), DeviceTrackerProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockAssemblerProtocol.self, method: "resolve() -> DeviceTrackerProtocol", parameterMatchers: matchers))
	    }
	    
	    func resolve() -> Cuckoo.ProtocolStubFunction<(), PersistenceHandlerProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockAssemblerProtocol.self, method: "resolve() -> PersistenceHandlerProtocol", parameterMatchers: matchers))
	    }
	    
	    func resolve() -> Cuckoo.ProtocolStubFunction<(), RequestHandlerProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockAssemblerProtocol.self, method: "resolve() -> RequestHandlerProtocol", parameterMatchers: matchers))
	    }
	    
	    func resolve() -> Cuckoo.ProtocolStubFunction<(), SendOrSaveHandlerProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockAssemblerProtocol.self, method: "resolve() -> SendOrSaveHandlerProtocol", parameterMatchers: matchers))
	    }
	    
	    func resolve() -> Cuckoo.ProtocolStubFunction<(), DateTimeHandlerProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockAssemblerProtocol.self, method: "resolve() -> DateTimeHandlerProtocol", parameterMatchers: matchers))
	    }
	    
	    func resolve() -> Cuckoo.ProtocolStubFunction<(), UserHandlerProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockAssemblerProtocol.self, method: "resolve() -> UserHandlerProtocol", parameterMatchers: matchers))
	    }
	    
	    func resolve() -> Cuckoo.ProtocolStubFunction<(), AlertHandlerProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockAssemblerProtocol.self, method: "resolve() -> AlertHandlerProtocol", parameterMatchers: matchers))
	    }
	    
	    func resolve() -> Cuckoo.ProtocolStubFunction<(), ChooseUserWindowProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockAssemblerProtocol.self, method: "resolve() -> ChooseUserWindowProtocol", parameterMatchers: matchers))
	    }
	    
	    func resolve() -> Cuckoo.ProtocolStubFunction<(), UsageBuilderProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockAssemblerProtocol.self, method: "resolve() -> UsageBuilderProtocol", parameterMatchers: matchers))
	    }
	    
	    func resolve() -> Cuckoo.ProtocolStubFunction<(), SetupHandlerProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockAssemblerProtocol.self, method: "resolve() -> SetupHandlerProtocol", parameterMatchers: matchers))
	    }
	    
	}

	struct __VerificationProxy_AssemblerProtocol: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	    init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func resolve() -> Cuckoo.__DoNotUse<LoggerProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("resolve() -> LoggerProtocol", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func resolve() -> Cuckoo.__DoNotUse<ActiveWindowHandlerProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("resolve() -> ActiveWindowHandlerProtocol", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func resolve() -> Cuckoo.__DoNotUse<SettingsProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("resolve() -> SettingsProtocol", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func resolve() -> Cuckoo.__DoNotUse<AppTrackerProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("resolve() -> AppTrackerProtocol", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func resolve() -> Cuckoo.__DoNotUse<DeviceTrackerProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("resolve() -> DeviceTrackerProtocol", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func resolve() -> Cuckoo.__DoNotUse<PersistenceHandlerProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("resolve() -> PersistenceHandlerProtocol", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func resolve() -> Cuckoo.__DoNotUse<RequestHandlerProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("resolve() -> RequestHandlerProtocol", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func resolve() -> Cuckoo.__DoNotUse<SendOrSaveHandlerProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("resolve() -> SendOrSaveHandlerProtocol", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func resolve() -> Cuckoo.__DoNotUse<DateTimeHandlerProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("resolve() -> DateTimeHandlerProtocol", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func resolve() -> Cuckoo.__DoNotUse<UserHandlerProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("resolve() -> UserHandlerProtocol", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func resolve() -> Cuckoo.__DoNotUse<AlertHandlerProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("resolve() -> AlertHandlerProtocol", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func resolve() -> Cuckoo.__DoNotUse<ChooseUserWindowProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("resolve() -> ChooseUserWindowProtocol", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func resolve() -> Cuckoo.__DoNotUse<UsageBuilderProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("resolve() -> UsageBuilderProtocol", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func resolve() -> Cuckoo.__DoNotUse<SetupHandlerProtocol> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("resolve() -> SetupHandlerProtocol", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class AssemblerProtocolStub: AssemblerProtocol {
    

    

    
     func resolve()  -> LoggerProtocol {
        return DefaultValueRegistry.defaultValue(for: LoggerProtocol.self)
    }
    
     func resolve()  -> ActiveWindowHandlerProtocol {
        return DefaultValueRegistry.defaultValue(for: ActiveWindowHandlerProtocol.self)
    }
    
     func resolve()  -> SettingsProtocol {
        return DefaultValueRegistry.defaultValue(for: SettingsProtocol.self)
    }
    
     func resolve()  -> AppTrackerProtocol {
        return DefaultValueRegistry.defaultValue(for: AppTrackerProtocol.self)
    }
    
     func resolve()  -> DeviceTrackerProtocol {
        return DefaultValueRegistry.defaultValue(for: DeviceTrackerProtocol.self)
    }
    
     func resolve()  -> PersistenceHandlerProtocol {
        return DefaultValueRegistry.defaultValue(for: PersistenceHandlerProtocol.self)
    }
    
     func resolve()  -> RequestHandlerProtocol {
        return DefaultValueRegistry.defaultValue(for: RequestHandlerProtocol.self)
    }
    
     func resolve()  -> SendOrSaveHandlerProtocol {
        return DefaultValueRegistry.defaultValue(for: SendOrSaveHandlerProtocol.self)
    }
    
     func resolve()  -> DateTimeHandlerProtocol {
        return DefaultValueRegistry.defaultValue(for: DateTimeHandlerProtocol.self)
    }
    
     func resolve()  -> UserHandlerProtocol {
        return DefaultValueRegistry.defaultValue(for: UserHandlerProtocol.self)
    }
    
     func resolve()  -> AlertHandlerProtocol {
        return DefaultValueRegistry.defaultValue(for: AlertHandlerProtocol.self)
    }
    
     func resolve()  -> ChooseUserWindowProtocol {
        return DefaultValueRegistry.defaultValue(for: ChooseUserWindowProtocol.self)
    }
    
     func resolve()  -> UsageBuilderProtocol {
        return DefaultValueRegistry.defaultValue(for: UsageBuilderProtocol.self)
    }
    
     func resolve()  -> SetupHandlerProtocol {
        return DefaultValueRegistry.defaultValue(for: SetupHandlerProtocol.self)
    }
    
}


// MARK: - Mocks generated from file: ActivityTrackerSDU/TrackerLib/Protocols/SettingsProtocol.swift at 2018-11-08 11:36:38 +0000

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
    

    

    
    // ["name": "addUser", "returnSignature": "", "fullyQualifiedName": "addUser(nameOfUser: String)", "parameterSignature": "nameOfUser: String", "parameterSignatureWithoutNames": "nameOfUser: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "nameOfUser", "call": "nameOfUser: nameOfUser", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("nameOfUser"), name: "nameOfUser", type: "String", range: CountableRange(261..<279), nameRange: CountableRange(261..<271))], "returnType": "Void", "isOptional": false, "escapingParameterNames": "nameOfUser", "stubFunction": "Cuckoo.ProtocolStubNoReturnFunction"]
     func addUser(nameOfUser: String)  {
        
            return cuckoo_manager.call("addUser(nameOfUser: String)",
                parameters: (nameOfUser),
                escapingParameters: (nameOfUser),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.addUser(nameOfUser: nameOfUser))
        
    }
    
    // ["name": "removeUser", "returnSignature": "", "fullyQualifiedName": "removeUser(nameOfUser: String)", "parameterSignature": "nameOfUser: String", "parameterSignatureWithoutNames": "nameOfUser: String", "inputTypes": "String", "isThrowing": false, "isInit": false, "isOverriding": false, "hasClosureParams": false, "@type": "ProtocolMethod", "accessibility": "", "parameterNames": "nameOfUser", "call": "nameOfUser: nameOfUser", "parameters": [CuckooGeneratorFramework.MethodParameter(label: Optional("nameOfUser"), name: "nameOfUser", type: "String", range: CountableRange(301..<319), nameRange: CountableRange(301..<311))], "returnType": "Void", "isOptional": false, "escapingParameterNames": "nameOfUser", "stubFunction": "Cuckoo.ProtocolStubNoReturnFunction"]
     func removeUser(nameOfUser: String)  {
        
            return cuckoo_manager.call("removeUser(nameOfUser: String)",
                parameters: (nameOfUser),
                escapingParameters: (nameOfUser),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.removeUser(nameOfUser: nameOfUser))
        
    }
    

	struct __StubbingProxy_SettingsProtocol: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	    init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    var appHasBeenSetup: Cuckoo.ProtocolToBeStubbedProperty<MockSettingsProtocol, Bool> {
	        return .init(manager: cuckoo_manager, name: "appHasBeenSetup")
	    }
	    
	    var userList: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockSettingsProtocol, [String]> {
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
	    
	    
	    func addUser<M1: Cuckoo.Matchable>(nameOfUser: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: nameOfUser) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockSettingsProtocol.self, method: "addUser(nameOfUser: String)", parameterMatchers: matchers))
	    }
	    
	    func removeUser<M1: Cuckoo.Matchable>(nameOfUser: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: nameOfUser) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockSettingsProtocol.self, method: "removeUser(nameOfUser: String)", parameterMatchers: matchers))
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
	    
	    var userList: Cuckoo.VerifyReadOnlyProperty<[String]> {
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
	    func addUser<M1: Cuckoo.Matchable>(nameOfUser: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: nameOfUser) { $0 }]
	        return cuckoo_manager.verify("addUser(nameOfUser: String)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func removeUser<M1: Cuckoo.Matchable>(nameOfUser: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: nameOfUser) { $0 }]
	        return cuckoo_manager.verify("removeUser(nameOfUser: String)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
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
    

    

    
     func addUser(nameOfUser: String)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func removeUser(nameOfUser: String)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}

*/
