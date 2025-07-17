//
//  MockNetworkClient.swift
//  AllSeeTests
//
//  Created by Jamie-Rhys Edwards on 16/07/2025.
//

import Foundation
@testable import AllSee

final class MockNetworkClient: NetworkClient {
    /*
    var handler: [((URL, [String : String]?, URLComponents?) async throws -> Data)]?
  
    func get(from url: URL, headers: [String : String]?) async throws -> Data {
        return try await handler?(url, headers, nil) ?? Data()
    }
    
    func post(to url: URL, headers: [String : String]? = nil, components: URLComponents) async throws -> Data {
        return try await handler?(url, headers, components) ?? Data()
    }
    */
    
    var handler: [(URL, [String : String]?, URLComponents?) async throws -> Data] = []
    
    func get(from url: URL, headers: [String : String]?) async throws -> Data {
        guard !handler.isEmpty else {
            fatalError("No responses left in queue")
        }
        
        let response = handler.removeFirst()
        return try await response(url, headers, nil)
    }
    
    func post(to url: URL, headers: [String : String]?, components: URLComponents) async throws -> Data {
        guard !handler.isEmpty else {
            fatalError("No responses left in queue")
        }
        
        let response = handler.removeFirst()
        return try await response(url, headers, components)
    }
}
