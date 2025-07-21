// MARK: - Mocks generated from file: 'AllSee/Core/Data/Local/KeyChain/KeyChain.swift'

import Cuckoo
import Foundation
@testable import AllSee

class MockKeyChainStorable: KeyChainStorable, Cuckoo.ProtocolMock, @unchecked Sendable {
    typealias MocksType = KeyChainStorable
    typealias Stubbing = __StubbingProxy_KeyChainStorable
    typealias Verification = __VerificationProxy_KeyChainStorable

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any KeyChainStorable)?

    func enableDefaultImplementation(_ stub: any KeyChainStorable) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    
    func insert(_ p0: Data, identifier p1: String, service p2: String) throws {
        return try cuckoo_manager.callThrows(
            "insert(_ p0: Data, identifier p1: String, service p2: String) throws",
            parameters: (p0, p1, p2),
            escapingParameters: (p0, p1, p2),
errorType: Error.self,            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.insert(p0, identifier: p1, service: p2)
        )
    }
    
    func get(identifier p0: String, service p1: String) throws -> String {
        return try cuckoo_manager.callThrows(
            "get(identifier p0: String, service p1: String) throws -> String",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
errorType: Error.self,            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.get(identifier: p0, service: p1)
        )
    }
    
    func update(_ p0: Data, identifier p1: String, service p2: String) throws {
        return try cuckoo_manager.callThrows(
            "update(_ p0: Data, identifier p1: String, service p2: String) throws",
            parameters: (p0, p1, p2),
            escapingParameters: (p0, p1, p2),
errorType: Error.self,            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.update(p0, identifier: p1, service: p2)
        )
    }
    
    func upsert(_ p0: Data, identifier p1: String, service p2: String) throws {
        return try cuckoo_manager.callThrows(
            "upsert(_ p0: Data, identifier p1: String, service p2: String) throws",
            parameters: (p0, p1, p2),
            escapingParameters: (p0, p1, p2),
errorType: Error.self,            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.upsert(p0, identifier: p1, service: p2)
        )
    }
    
    func delete(identifier p0: String, service p1: String) throws {
        return try cuckoo_manager.callThrows(
            "delete(identifier p0: String, service p1: String) throws",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
errorType: Error.self,            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: __defaultImplStub!.delete(identifier: p0, service: p1)
        )
    }

    struct __StubbingProxy_KeyChainStorable: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func insert<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(_ p0: M1, identifier p1: M2, service p2: M3) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(Data, String, String),Error> where M1.MatchedType == Data, M2.MatchedType == String, M3.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(Data, String, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainStorable.self,
                method: "insert(_ p0: Data, identifier p1: String, service p2: String) throws",
                parameterMatchers: matchers
            ))
        }
        
        func get<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(identifier p0: M1, service p1: M2) -> Cuckoo.ProtocolStubThrowingFunction<(String, String), String,Error> where M1.MatchedType == String, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainStorable.self,
                method: "get(identifier p0: String, service p1: String) throws -> String",
                parameterMatchers: matchers
            ))
        }
        
        func update<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(_ p0: M1, identifier p1: M2, service p2: M3) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(Data, String, String),Error> where M1.MatchedType == Data, M2.MatchedType == String, M3.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(Data, String, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainStorable.self,
                method: "update(_ p0: Data, identifier p1: String, service p2: String) throws",
                parameterMatchers: matchers
            ))
        }
        
        func upsert<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(_ p0: M1, identifier p1: M2, service p2: M3) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(Data, String, String),Error> where M1.MatchedType == Data, M2.MatchedType == String, M3.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(Data, String, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainStorable.self,
                method: "upsert(_ p0: Data, identifier p1: String, service p2: String) throws",
                parameterMatchers: matchers
            ))
        }
        
        func delete<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(identifier p0: M1, service p1: M2) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(String, String),Error> where M1.MatchedType == String, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockKeyChainStorable.self,
                method: "delete(identifier p0: String, service p1: String) throws",
                parameterMatchers: matchers
            ))
        }
    }

    struct __VerificationProxy_KeyChainStorable: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func insert<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(_ p0: M1, identifier p1: M2, service p2: M3) -> Cuckoo.__DoNotUse<(Data, String, String), Void> where M1.MatchedType == Data, M2.MatchedType == String, M3.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(Data, String, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return cuckoo_manager.verify(
                "insert(_ p0: Data, identifier p1: String, service p2: String) throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func get<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(identifier p0: M1, service p1: M2) -> Cuckoo.__DoNotUse<(String, String), String> where M1.MatchedType == String, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "get(identifier p0: String, service p1: String) throws -> String",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func update<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(_ p0: M1, identifier p1: M2, service p2: M3) -> Cuckoo.__DoNotUse<(Data, String, String), Void> where M1.MatchedType == Data, M2.MatchedType == String, M3.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(Data, String, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return cuckoo_manager.verify(
                "update(_ p0: Data, identifier p1: String, service p2: String) throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func upsert<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(_ p0: M1, identifier p1: M2, service p2: M3) -> Cuckoo.__DoNotUse<(Data, String, String), Void> where M1.MatchedType == Data, M2.MatchedType == String, M3.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(Data, String, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return cuckoo_manager.verify(
                "upsert(_ p0: Data, identifier p1: String, service p2: String) throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func delete<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(identifier p0: M1, service p1: M2) -> Cuckoo.__DoNotUse<(String, String), Void> where M1.MatchedType == String, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "delete(identifier p0: String, service p1: String) throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

class KeyChainStorableStub:KeyChainStorable, @unchecked Sendable {


    
    func insert(_ p0: Data, identifier p1: String, service p2: String) throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    func get(identifier p0: String, service p1: String) throws -> String {
        return DefaultValueRegistry.defaultValue(for: (String).self)
    }
    
    func update(_ p0: Data, identifier p1: String, service p2: String) throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    func upsert(_ p0: Data, identifier p1: String, service p2: String) throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    func delete(identifier p0: String, service p1: String) throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}




// MARK: - Mocks generated from file: 'AllSee/Core/Data/Remote/Client/NetworkClient.swift'

import Cuckoo
import Foundation
import OSLog
@testable import AllSee

class MockNetworkClient: NetworkClient, Cuckoo.ProtocolMock, @unchecked Sendable {
    typealias MocksType = NetworkClient
    typealias Stubbing = __StubbingProxy_NetworkClient
    typealias Verification = __VerificationProxy_NetworkClient

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any NetworkClient)?

    func enableDefaultImplementation(_ stub: any NetworkClient) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    
    func get(from p0: URL, headers p1: [String : String]?) async throws -> Data {
        return try await cuckoo_manager.callThrows(
            "get(from p0: URL, headers p1: [String : String]?) async throws -> Data",
            parameters: (p0, p1),
            escapingParameters: (p0, p1),
errorType: Error.self,            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.get(from: p0, headers: p1)
        )
    }
    
    func post(to p0: URL, headers p1: [String : String]?, components p2: URLComponents) async throws -> Data {
        return try await cuckoo_manager.callThrows(
            "post(to p0: URL, headers p1: [String : String]?, components p2: URLComponents) async throws -> Data",
            parameters: (p0, p1, p2),
            escapingParameters: (p0, p1, p2),
errorType: Error.self,            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.post(to: p0, headers: p1, components: p2)
        )
    }

    struct __StubbingProxy_NetworkClient: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func get<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(from p0: M1, headers p1: M2) -> Cuckoo.ProtocolStubThrowingFunction<(URL, [String : String]?), Data,Error> where M1.MatchedType == URL, M2.OptionalMatchedType == [String : String] {
            let matchers: [Cuckoo.ParameterMatcher<(URL, [String : String]?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockNetworkClient.self,
                method: "get(from p0: URL, headers p1: [String : String]?) async throws -> Data",
                parameterMatchers: matchers
            ))
        }
        
        func post<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable>(to p0: M1, headers p1: M2, components p2: M3) -> Cuckoo.ProtocolStubThrowingFunction<(URL, [String : String]?, URLComponents), Data,Error> where M1.MatchedType == URL, M2.OptionalMatchedType == [String : String], M3.MatchedType == URLComponents {
            let matchers: [Cuckoo.ParameterMatcher<(URL, [String : String]?, URLComponents)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockNetworkClient.self,
                method: "post(to p0: URL, headers p1: [String : String]?, components p2: URLComponents) async throws -> Data",
                parameterMatchers: matchers
            ))
        }
    }

    struct __VerificationProxy_NetworkClient: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func get<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(from p0: M1, headers p1: M2) -> Cuckoo.__DoNotUse<(URL, [String : String]?), Data> where M1.MatchedType == URL, M2.OptionalMatchedType == [String : String] {
            let matchers: [Cuckoo.ParameterMatcher<(URL, [String : String]?)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }]
            return cuckoo_manager.verify(
                "get(from p0: URL, headers p1: [String : String]?) async throws -> Data",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func post<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable>(to p0: M1, headers p1: M2, components p2: M3) -> Cuckoo.__DoNotUse<(URL, [String : String]?, URLComponents), Data> where M1.MatchedType == URL, M2.OptionalMatchedType == [String : String], M3.MatchedType == URLComponents {
            let matchers: [Cuckoo.ParameterMatcher<(URL, [String : String]?, URLComponents)>] = [wrap(matchable: p0) { $0.0 }, wrap(matchable: p1) { $0.1 }, wrap(matchable: p2) { $0.2 }]
            return cuckoo_manager.verify(
                "post(to p0: URL, headers p1: [String : String]?, components p2: URLComponents) async throws -> Data",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

class NetworkClientStub:NetworkClient, @unchecked Sendable {


    
    func get(from p0: URL, headers p1: [String : String]?) async throws -> Data {
        return DefaultValueRegistry.defaultValue(for: (Data).self)
    }
    
    func post(to p0: URL, headers p1: [String : String]?, components p2: URLComponents) async throws -> Data {
        return DefaultValueRegistry.defaultValue(for: (Data).self)
    }
}




// MARK: - Mocks generated from file: 'AllSee/Core/Data/Remote/Service/StarlingBankApiService.swift'

import Cuckoo
import Foundation
import OSLog
@testable import AllSee

class MockStarlingBankApiService: StarlingBankApiService, Cuckoo.ProtocolMock, @unchecked Sendable {
    typealias MocksType = StarlingBankApiService
    typealias Stubbing = __StubbingProxy_StarlingBankApiService
    typealias Verification = __VerificationProxy_StarlingBankApiService

    // Original typealiases

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    private var __defaultImplStub: (any StarlingBankApiService)?

    func enableDefaultImplementation(_ stub: any StarlingBankApiService) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    
    func fetchAccounts() async throws -> AccountsDto {
        return try await cuckoo_manager.callThrows(
            "fetchAccounts() async throws -> AccountsDto",
            parameters: (),
            escapingParameters: (),
errorType: Error.self,            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.fetchAccounts()
        )
    }
    
    func fetchIndividualInformation() async throws -> IndividualDto {
        return try await cuckoo_manager.callThrows(
            "fetchIndividualInformation() async throws -> IndividualDto",
            parameters: (),
            escapingParameters: (),
errorType: Error.self,            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.fetchIndividualInformation()
        )
    }
    
    func refreshAccessToken() async throws {
        return try await cuckoo_manager.callThrows(
            "refreshAccessToken() async throws",
            parameters: (),
            escapingParameters: (),
errorType: Error.self,            superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall(),
            defaultCall: await __defaultImplStub!.refreshAccessToken()
        )
    }

    struct __StubbingProxy_StarlingBankApiService: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        func fetchAccounts() -> Cuckoo.ProtocolStubThrowingFunction<(), AccountsDto,Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockStarlingBankApiService.self,
                method: "fetchAccounts() async throws -> AccountsDto",
                parameterMatchers: matchers
            ))
        }
        
        func fetchIndividualInformation() -> Cuckoo.ProtocolStubThrowingFunction<(), IndividualDto,Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockStarlingBankApiService.self,
                method: "fetchIndividualInformation() async throws -> IndividualDto",
                parameterMatchers: matchers
            ))
        }
        
        func refreshAccessToken() -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(),Error> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockStarlingBankApiService.self,
                method: "refreshAccessToken() async throws",
                parameterMatchers: matchers
            ))
        }
    }

    struct __VerificationProxy_StarlingBankApiService: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        @discardableResult
        func fetchAccounts() -> Cuckoo.__DoNotUse<(), AccountsDto> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "fetchAccounts() async throws -> AccountsDto",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func fetchIndividualInformation() -> Cuckoo.__DoNotUse<(), IndividualDto> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "fetchIndividualInformation() async throws -> IndividualDto",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
        
        
        @discardableResult
        func refreshAccessToken() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
                "refreshAccessToken() async throws",
                callMatcher: callMatcher,
                parameterMatchers: matchers,
                sourceLocation: sourceLocation
            )
        }
    }
}

class StarlingBankApiServiceStub:StarlingBankApiService, @unchecked Sendable {


    
    func fetchAccounts() async throws -> AccountsDto {
        return DefaultValueRegistry.defaultValue(for: (AccountsDto).self)
    }
    
    func fetchIndividualInformation() async throws -> IndividualDto {
        return DefaultValueRegistry.defaultValue(for: (IndividualDto).self)
    }
    
    func refreshAccessToken() async throws {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
}


