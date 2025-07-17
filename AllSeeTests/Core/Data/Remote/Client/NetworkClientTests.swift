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
/*
 * ================================================================================
 * Setup and Teardown
 * ================================================================================
 */
    var sut: NetworkClient!
    var log: Logger!
    
    private let mockBaseURL = "https://api.mock.com"
    
    override func setUp() {
        super.setUp()
        
        log = Logger()
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        
        let session = URLSession(configuration: config)
        
        sut = NetworkClientImpl(session: session, log: log)
    }
    
    override func tearDown() {
        MockURLProtocol.handler = nil
        super.tearDown()
    }
    
/*
 * ================================================================================
 * Get method
 * ================================================================================
 */
    
    func test_GetSuccess() async throws {
        let expectedData = "Hello, world!".data(using: .utf8)!
        
        MockURLProtocol.handler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, expectedData)
        }
        
        let url = URL(string: mockBaseURL)!
        let data = try await sut.get(from: url, headers: nil)
        
        XCTAssertEqual(data, expectedData)
    }
    
    func test_GetBadStatusCode() async throws {
        let responseData = Data()
        
        MockURLProtocol.handler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (response, responseData)
        }
        
        let url = URL(string: mockBaseURL)!
        
        do {
            _ = try await sut.get(from: url, headers: nil)
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
    
    func test_GetTimedOut() async {
        MockURLProtocol.handler = { _ in
            throw URLError(.timedOut)
        }
        
        let url = URL(string: mockBaseURL)!
        
        do {
            _ = try await sut.get(from: url, headers: nil)
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
    
    func test_GetNotConnectedToInternet() async {
        MockURLProtocol.handler = { _ in throw URLError(.notConnectedToInternet) }
        
        let url = URL(string: mockBaseURL)!
        
        do {
            _ = try await sut.get(from: url, headers: nil)
            XCTFail("Expected NetworkError.notConnectedToInternet")
        } catch let error as NetworkError {
            switch error {
            case NetworkError.notConnectedToTheInternet:
                XCTAssertTrue(true)
            default:
                XCTFail("Expected NetworkError.notConnectedToInternet")
            }
        } catch {
            XCTFail("Expected NetworkError.notConnectedToInternet")
        }
    }
    
    func test_GetBadURL() async {
        MockURLProtocol.handler = { _ in throw URLError(.badURL) }
        
        let url = URL(string: mockBaseURL)!
        
        do {
            _ = try await sut.get(from: url, headers: nil)
            XCTFail("Expected NetworkError.invalidUrl")
        } catch let error as NetworkError {
            switch error {
            case NetworkError.invalidUrl:
                XCTAssertTrue(true)
            default:
                XCTFail("Expected NetworkError.invalidUrl")
            }
        } catch {
            XCTFail("Expected NetworkError.invalidUrl")
        }
    }
    
    func test_GetUnknownNetworkError() async {
        MockURLProtocol.handler = { _ in throw URLError(.unknown) }
        
        let url = URL(string: mockBaseURL)!
        
        do {
            _ = try await sut.get(from: url, headers: nil)
            XCTFail("Expected NetworkError.unknownError")
        } catch let error as NetworkError {
            switch error {
            case NetworkError.unknownError:
                XCTAssertTrue(true)
            default:
                XCTFail("Expected NetworkError.unknownError")
            }
        } catch {
            XCTFail("Expected NetworkError.unknownError")
        }
    }

/*
 * ================================================================================
 * Get method
 * ================================================================================
 */
    
    func test_PostSuccess() async throws {
        let expectedData = "Success".data(using: .utf8)!
        
        MockURLProtocol.handler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
            
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, expectedData)
        }
        
        let url = URL(string: mockBaseURL)!
        var components = URLComponents()
        components.queryItems = [URLQueryItem(name: "key", value: "value")]
        
        let data = try await sut.post(to: url, headers: ["Content-Type": "application/json"], components: components)
        
        XCTAssertEqual(data, expectedData)
    }
    
    func test_PostTimedOut() async throws {
        MockURLProtocol.handler = { _ in
            throw URLError(.timedOut)
        }
        
        let url = URL(string: mockBaseURL)!
        var components = URLComponents()
        components.queryItems = [URLQueryItem(name: "key", value: "value")]
        
        do {
            _ = try await sut.post(to: url, headers: nil, components: components)
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
    
    func test_PostNotConnectedToInternet() async {
        MockURLProtocol.handler = { _ in throw URLError(.notConnectedToInternet) }
        
        let url = URL(string: mockBaseURL)!
        var components = URLComponents()
        components.queryItems = [URLQueryItem(name: "key", value: "value")]
        
        do {
            _ = try await sut.post(
                to: url,
                headers: nil,
                components: components
            )
            XCTFail("Expected NetworkError.notConnectedToInternet")
        } catch let error as NetworkError {
            switch error {
            case NetworkError.notConnectedToTheInternet:
                XCTAssertTrue(true)
            default:
                XCTFail("Expected NetworkError.notConnectedToInternet, got \(error)")
            }
        } catch {
            XCTFail("Expected NetworkError.notConnectedToInternet, got \(error)")
        }
    }
    
    func test_PostBadURL() async {
        MockURLProtocol.handler = { _ in throw URLError(.badURL) }
        
        let url = URL(string: mockBaseURL)!
        var components = URLComponents()
        components.queryItems = [URLQueryItem(name: "key", value: "value")]
        
        do {
            _ = try await sut.post(
                to: url,
                headers: nil,
                components: components
            )
            XCTFail("Expected NetworkError.invalidUrl")
        } catch let error as NetworkError {
            switch error {
            case NetworkError.invalidUrl:
                XCTAssertTrue(true)
            default:
                XCTFail("Expected NetworkError.invalidUrl, got \(error)")
            }
        } catch {
            XCTFail("Expected NetworkError.invalidUrl, got \(error)")
        }
    }
    
    func test_PostUnknownError() async {
        MockURLProtocol.handler = { _ in throw URLError(.unknown) }
        
        let url = URL(string: mockBaseURL)!
        var components = URLComponents()
        components.queryItems = [URLQueryItem(name: "key", value: "value")]
        
        do {
            _ = try await sut.post(
                to: url,
                headers: nil,
                components: components
            )
            XCTFail("Expected NetworkError.unknownError")
        } catch let error as NetworkError {
            switch error {
            case NetworkError.unknownError:
                XCTAssertTrue(true)
            default:
                XCTFail("Expected NetworkError.unknownError, got \(error)")
            }
        } catch {
            XCTFail("Expected NetworkError.unknownError, got \(error)")
        }
    }
    
    func test_PostBadServerResponse() async {
        let responseData = Data()
        
        MockURLProtocol.handler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 403, httpVersion: nil, headerFields: nil)!
            return (response, responseData)
        }
        
        let url = URL(string: mockBaseURL)!
        var components = URLComponents()
        components.queryItems = [URLQueryItem(name: "key", value: "value")]
        
        do {
            _ = try await sut.post(
                to: url,
                headers: nil,
                components: components
            )
            XCTFail("Expected NetworkError.badServerResponse")
        } catch let error as NetworkError {
            switch error {
            case NetworkError.badServerResponse:
                XCTAssertTrue(true)
            default:
                XCTFail("Expected NetworkError.badServerResponse, got \(error)")
            }
        } catch {
            XCTFail("Expected NetworkError.badServerResponse, got \(error)")
        }
    }
}
