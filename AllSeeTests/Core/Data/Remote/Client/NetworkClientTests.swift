//
//  NetworkClientTests.swift
//  AllSeeTests
//
//  Created by Jamie-Rhys Edwards on 15/07/2025.
//

import XCTest
import OSLog
@testable import AllSee

final class NetworkClientTests: XCTestCase {
    var sut: NetworkClient!
    var log: Logger!
    
    override func setUp() {
        super.setUp()
        
        log = Logger()
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        
        let session = URLSession(configuration: config)
        
        sut = NetworkClient(session: session, log: log)
    }
    
    override func tearDown() {
        MockURLProtocol.handler = nil
        super.tearDown()
    }
    
    func testGetSuccess() async throws {
        let expectedData = "Hello, world!".data(using: .utf8)!
        
        MockURLProtocol.handler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, expectedData)
        }
        
        let url = URL(string: "https://mockapi.com")!
        let data = try await sut.get(from: url)
        
        XCTAssertEqual(data, expectedData)
    }
    
    func testGetBadStatusCode() async throws {
        let responseData = Data()
        
        MockURLProtocol.handler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (response, responseData)
        }
        
        let url = URL(string: "https://mockapi.com")!
        
        do {
            _ = try await sut.get(from: url)
            XCTFail("Expected NetworkError.badServerResponse")
        } catch let error as NetworkError {
            switch error {
            case .badServerResponse(let statusCode, _):
                XCTAssertEqual(statusCode, 500)
            default:
                XCTFail("Unexpected NetworkError: \(error)")
            }
        }
    }
    
    func testGetTimedOut() async {
        MockURLProtocol.handler = { _ in
            throw URLError(.timedOut)
        }
        
        let url = URL(string: "https://mockapi.com")!
        
        do {
            _ = try await sut.get(from: url)
            XCTFail("Expected NetworkError.requestTimedOut")
        } catch let error as NetworkError {
            switch error {
            case NetworkError.requestTimedOut:
                XCTAssertTrue(true)
            default:
                XCTFail("Expected NetworkError.requestTimedOut, got \(error)")
            }
        } catch {
            XCTFail("Expected NetworkError.requestTimedOut, got \(error)")
        }
    }
}
