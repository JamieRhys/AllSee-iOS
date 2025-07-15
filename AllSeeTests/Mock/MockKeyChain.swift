//
//  MockKeyChain.swift
//  AllSeeTests
//
//  Created by Jamie-Rhys Edwards on 15/07/2025.
//

import XCTest
@testable import AllSee

final class MockKeyChain: KeyChainStorable {
    var storage: [String : Data] = [:]
    
    func insert(_ token: Data, identifier: String, service: String) throws {
        let key = "\(service).\(identifier)"
        if storage[key] != nil { throw KeyChain.Errors.duplicateItem }
        storage[key] = token
    }
    
    func get(identifier: String, service: String) throws -> String {
        let key = "\(service).\(identifier)"
        guard let data = storage[key] else { throw KeyChain.Errors.itemNotFound }
        return String(data: data, encoding: .utf8)!
    }
    
    func update(_ token: Data, identifier: String, service: String) throws {
        let key = "\(service).\(identifier)"
        guard storage[key] != nil else { throw KeyChain.Errors.itemNotFound }
        storage[key] = token
    }
    
    func upsert(_ token: Data, identifier: String, service: String) throws {
        let key = "\(service).\(identifier)"
        
        do {
            try update(token, identifier: identifier, service: service)
        } catch let error as KeyChain.Errors {
            switch error {
            case KeyChain.Errors.itemNotFound:
                try insert(token, identifier: identifier, service: service)
            default:
                print() // No Op. This should never be reachable.
            }
        }
    }
    
    func delete(identifier: String, service: String) throws {
        let key = "\(service).\(identifier)"
        
        storage.removeValue(forKey: key)
    }
    
    
}
