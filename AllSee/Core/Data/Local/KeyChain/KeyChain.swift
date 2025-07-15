//
//  KeyChain.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 13/07/2025.
//

import Foundation

protocol KeyChainStorable {
    /// Inserts the given Data token into the device keychain.
    /// - Parameters:
    ///   - token: The token to be added.
    ///   - identifier: The name used to store the token under.
    ///   - service: The service to store related tokens under. This is normally the package structure for the app.
    func insert(_ token: Data, identifier: String, service: String) throws
    
    /// Searches the device Keychain. If the entry is found, it then returns the value of the token.
    /// - Parameters:
    ///   - identifier: The name used to store the token under.
    ///   - service: The service to store related tokens under. This is normally the package structure for the app.
    /// - Returns: The token as a String type.
    func get(identifier: String, service: String) throws -> String
    
    /// Searches the device Keychain. If the token exists, this then updates the token to the new provided token.
    /// - Parameters:
    ///   - token: The value to update.
    ///   - identifier: The name of the token entry to be updated within the keychain.
    ///   - service: The service to store related tokens under. This is normally the package structure for the app.
    func update(_ token: Data, identifier: String, service: String) throws
    
    /// Searches the device Keychain. If the entry does not exist, it creates a new entry, updates it otherwise.
    /// - Parameters:
    ///   - token: The value to create or update to.
    ///   - identifier: The name of the token entry to be updated or created within the keychain.
    ///   - service: The service to store related tokens under. This is normally the package structure for the app.
    func upsert(_ token: Data, identifier: String, service: String) throws
    
    /// Searches the device Keychain and if the entry exists, it will delete the entry.
    /// - Parameters:
    ///   - identifier: The name of the token to be deleted.
    ///   - service: The service to store related tokens under. This is normally the package structure for the app.
    func delete(identifier: String, service: String) throws
}

final class KeyChain : KeyChainStorable {
    enum Errors: Error {
        case itemNotFound
        case duplicateItem
        case unexpectedStatus(OSStatus)
    }
    
    /// Inserts the given Data token into the device keychain.
    /// - Parameters:
    ///   - token: The token to be added.
    ///   - identifier: The name used to store the token under.
    ///   - service: The service to store related tokens under. This is normally the package structure for the app.
    func insert(_ token: Data, identifier: String, service: String) throws {
        let attributes = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: identifier,
            kSecValueData: token,
        ] as CFDictionary
        
        let status = SecItemAdd(attributes, nil)
        guard status == errSecSuccess else {
            if status == errSecDuplicateItem {
                throw KeyChain.Errors.duplicateItem
            }
            throw KeyChain.Errors.unexpectedStatus(status)
        }
    }
    
    
    /// Searches the device Keychain. If the entry is found, it then returns the value of the token.
    /// - Parameters:
    ///   - identifier: The name used to store the token under.
    ///   - service: The service to store related tokens under. This is normally the package structure for the app.
    /// - Returns: The token as a String type.
    func get(identifier: String, service: String) throws -> String {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: identifier,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                throw KeyChain.Errors.itemNotFound
            }
            
            throw KeyChain.Errors.unexpectedStatus(status)
        }
        
        return String(data: result as! Data, encoding: .utf8)!
    }
    
    
    /// Searches the device Keychain. If the token exists, this then updates the token to the new provided token.
    /// - Parameters:
    ///   - token: The value to update.
    ///   - identifier: The name of the token entry to be updated within the keychain.
    ///   - service: The service to store related tokens under. This is normally the package structure for the app.
    func update(_ token: Data, identifier: String, service: String) throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: identifier,
        ] as CFDictionary
        
        let attributes = [
            kSecValueData: token,
        ] as CFDictionary
        
        let status = SecItemUpdate(query, attributes)
        
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                throw KeyChain.Errors.itemNotFound
            }
            
            throw KeyChain.Errors.unexpectedStatus(status)
        }
    }
    
    /// Searches the device Keychain. If the entry does not exist, it creates a new entry, updates it otherwise.
    /// - Parameters:
    ///   - token: The value to create or update to.
    ///   - identifier: The name of the token entry to be updated or created within the keychain.
    ///   - service: The service to store related tokens under. This is normally the package structure for the app.
    func upsert(_ token: Data, identifier: String, service: String) throws {
        do {
            _ = try get(identifier: identifier, service: service)
            try update(token, identifier: identifier, service: service)
        } catch KeyChain.Errors.itemNotFound {
            try insert(token, identifier: identifier, service: service)
        }
    }
    
    
    /// Searches the device Keychain and if the entry exists, it will delete the entry.
    /// - Parameters:
    ///   - identifier: The name of the token to be deleted.
    ///   - service: The service to store related tokens under. This is normally the package structure for the app.
    func delete(identifier: String, service: String) throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: identifier,
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeyChain.Errors.unexpectedStatus(status)
        }
    }
}
