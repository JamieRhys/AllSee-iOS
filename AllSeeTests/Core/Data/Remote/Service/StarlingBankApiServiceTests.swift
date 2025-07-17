//
//  StarlingBankApiServiceTests.swift
//  AllSeeTests
//
//  Created by Jamie-Rhys Edwards on 16/07/2025.
//

@testable import AllSee
import OSLog
import XCTest

final class StarlingBankApiServiceTests: XCTestCase {
/*
 * ==========================================================================
 * Setup and Teardown
 * ==========================================================================
 */
    
    var sut: StarlingBankApiService!
    var networkClient: MockNetworkClient!
    var log: Logger!
    var keyChain: KeyChainStorable!
    
    override func setUp() {
        super.setUp()
        
        keyChain = MockKeyChain()
        log = Logger()
        networkClient = MockNetworkClient()
        
        sut = StarlingBankApiServiceImpl(
            keyChain: keyChain,
            log: log,
            networkClient: networkClient)
    }
    
/*
 * ==========================================================================
 * Fetch Accounts
 * ==========================================================================
 */
    
    func test_fetchAccounts_Success() async {
        do {
            try keyChain.insert(
                "access-token".data(using: .utf8)!,
                identifier: KeyChainTokens.accessTokenIdentifier,
                service: KeyChainTokens.service
            )
        } catch {
            XCTFail("Could not insert keychain.")
        }
        
        let expected = AccountsDto(
            accounts: [
                AccountDto(
                    accountUid: "some-uid",
                    accountType: "some-account-type",
                    defaultCategory: "some-default-category",
                    currency: "GBP",
                    createdAt: "2025-07-17",
                    name: "Persaonal"
                )
            ]
        )
        
        networkClient.handler.append({ _, _, _ in
            return try JSONEncoder().encode(expected)
        })
        
        guard let actual = try? await sut.fetchAccounts() else {
            XCTFail("Failed to fetch accounts.")
            return // to satisfy xcode
        }
        
        XCTAssertEqual(expected.accounts[0].accountUid, actual.accounts[0].accountUid)
        XCTAssertEqual(expected.accounts[0].accountType, actual.accounts[0].accountType)
    }
    
    func test_fetchAccounts_MissingAccessToken() async {
        let freshToken = FreshAccessTokenDto(
            access_token: "fresh_access-token",
            refresh_token: "fresh_refresh-token",
            token_type: "refresh-token",
            expires_in: 3600,
            scope: "bunch; of; different; scopes;"
        )
        
        let expected = AccountsDto(
            accounts: [
                AccountDto(
                    accountUid: "some-uid",
                    accountType: "some-account-type",
                    defaultCategory: "some-default-category",
                    currency: "GBP",
                    createdAt: "2025-07-17",
                    name: "Persaonal"
                )
            ]
        )
        do {
            try keyChain.insert(
                "access-token".data(using: .utf8)!,
                identifier: KeyChainTokens.accessTokenIdentifier,
                service: KeyChainTokens.service
            )
            try keyChain.insert(
                "refresh-token".data(using: .utf8)!,
                identifier: KeyChainTokens.refreshTokenIdentifier,
                service: KeyChainTokens.service
            )
        } catch {
            XCTFail("Could not insert keychain.")
        }
        
        let errorResponse = ApiErrorDto(
            error: "invalid_token",
            errorDescription: "Unable to validate token. Might it be expired?"
        )
        let errorData = try! JSONEncoder().encode(errorResponse)
        
        networkClient.handler.append({ _, _, _ in
            throw NetworkError.badServerResponse(statusCode: 403, data: errorData)
        })
        networkClient.handler.append({ _, _, _ in
            return try JSONEncoder().encode(freshToken)
        })
        networkClient.handler.append({ _, _, _ in
            return try JSONEncoder().encode(expected)
        })
        
        do {
            let actual = try await sut.fetchAccounts()
            
            XCTAssertEqual(
                expected.accounts.count,
                actual.accounts.count
            )
        } catch {
            XCTFail("Expected to pass. Got \(error)")
        }
    }
    
    func test_fetchAccounts_UnknownBadServerResponseStatusCode() async {
        do {
            try keyChain.insert(
                "access-token".data(using: .utf8)!,
                identifier: KeyChainTokens.accessTokenIdentifier,
                service: KeyChainTokens.service
            )
            try keyChain.insert(
                "refresh-token".data(using: .utf8)!,
                identifier: KeyChainTokens.refreshTokenIdentifier,
                service: KeyChainTokens.service
            )
        } catch {
            XCTFail("Could not insert keychain.")
        }
        
        let errorResponse = ApiErrorDto(
            error: "unknown_error",
            errorDescription: "",
        )
        let errorData = try! JSONEncoder().encode(errorResponse)
        
        networkClient.handler.append({ _, _, _ in
            throw NetworkError.badServerResponse(statusCode: 404, data: errorData)
        })
        
        do {
            _ = try await sut.fetchAccounts()
            XCTFail("Expected ApiError.invalidResponse to be thrown.")
        } catch let error as ApiError {
            switch error {
            case ApiError.invalidResponse:
                XCTAssertTrue(true)
            default:
                XCTFail("Expected ApiError.invalidResponse, got: \(error)")
            }
        } catch {
            XCTFail("Expected ApiError.invalidResponse, got: \(error)")
        }
    }
    
    // TODO: Network Error - Ensure function knows how to handle a network error. (e.g. timedOut)
    
    func test_fetchAccounts_NetworkError() async {
        do {
            try keyChain.insert(
                "access-token".data(using: .utf8)!,
                identifier: KeyChainTokens.accessTokenIdentifier,
                service: KeyChainTokens.service
            )
            try keyChain.insert(
                "refresh-token".data(using: .utf8)!,
                identifier: KeyChainTokens.refreshTokenIdentifier,
                service: KeyChainTokens.service
            )
        } catch {
            XCTFail("Could not insert keychain.")
        }
        
        networkClient.handler.append({ _, _, _ in
            throw NetworkError.requestTimedOut
        })
        
        do {
            _ = try await sut.fetchAccounts()
            XCTFail("Expected NetworkError.requestTimedOut to be thrown")
        } catch let error as ApiError {
            switch error {
            case ApiError.invalidResponse:
                XCTAssertTrue(true)
            default:
                XCTFail("Expected ApiError.invalidResponse to be thrown, got: \(error)")
            }
        } catch {
            XCTFail("Expected ApiError.invalidResponse to be thrown, got: \(error)")
        }
    }
    
    // TODO: JSON decode failure - Ensure function correctly throws dataCorrupted.
    
    func test_fetchAccounts_JsonDecodeFailureWhenDecodingReturnedData() async {
        do {
            try keyChain.insert(
                "access-token".data(using: .utf8)!,
                identifier: KeyChainTokens.accessTokenIdentifier,
                service: KeyChainTokens.service
            )
        } catch {
            XCTFail("Could not insert keychain.")
        }
        
        networkClient.handler.append({ _, _, _ in
            return "Unusable Json Data".data(using: .utf8)!
        })
        
        do {
            _ = try await sut.fetchAccounts()
        } catch let error as ApiError {
            switch error {
            case .dataCorrupted:
                XCTAssertTrue(true)
            default:
                XCTFail("Expected ApiError.dataCorrupted, got \(error)")
            }
        } catch {
            XCTFail("Expected ApiError.dataCorrupted, got \(error)")
        }
    }
    
    // TODO: Ensure function knows how to handle an unknown error.
    
/*
 * ==========================================================================
 * Refresh Access Token
 * ==========================================================================
 */
    
    func test_refreshAccessToken_Success() async {
        let expected = FreshAccessTokenDto(
            access_token: "fresh_access-token",
            refresh_token: "fresh_refresh-token",
            token_type: "refresh-token",
            expires_in: 3600,
            scope: "bunch; of; different; scopes;"
        )
        
        networkClient.handler.append({ _, _, _ in
            return try JSONEncoder().encode(expected)
        })
        do {
            try keyChain.insert(
                "refresh-token".data(using: .utf8)!,
                identifier: KeyChainTokens.refreshTokenIdentifier,
                service: KeyChainTokens.service
            )
        } catch {
            XCTFail("Could not insert keychain.")
        }
        
        do {
            try await sut.refreshAccessToken()
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
        
        XCTAssertEqual(
            expected.access_token,
            try keyChain.get(identifier: KeyChainTokens.accessTokenIdentifier, service: KeyChainTokens.service)
        )
        XCTAssertEqual(
            expected.refresh_token,
            try keyChain.get(identifier: KeyChainTokens.refreshTokenIdentifier, service: KeyChainTokens.service)
        )
    }
    
    func test_refreshAccessToken_MissingRefreshToken() async {
        do {
            _ = try await sut.refreshAccessToken()
            XCTFail("Expected ApiError.missingRefreshToken")
        } catch let error as ApiError {
            switch error {
            case ApiError.missingRefreshToken:
                XCTAssertTrue(true)
            default:
                XCTFail("Expected ApiError.missingRefreshToken, got \(error)")
            }
        } catch {
            XCTFail("Expected ApiError.missingRefreshToken, got \(error)")
        }
    }
    
    func test_refreshAccessToken_NetworkError() async {
        do {
            try keyChain.insert(
                "refresh-token".data(using: .utf8)!,
                identifier: KeyChainTokens.refreshTokenIdentifier,
                service: KeyChainTokens.service
            )
        } catch {
            XCTFail("Could not insert keychain.")
        }
        networkClient.handler.append({ _, _, _ in
            throw NetworkError.requestTimedOut
        })
        
        do {
            _ = try await sut.refreshAccessToken()
        } catch let error as ApiError {
            switch error {
            case ApiError.invalidResponse:
                XCTAssertTrue(true)
            default: XCTFail("Expected ApiError.invalidResponse, got \(error)")
            }
        } catch {
            XCTFail("Expected ApiError.invalidResponse, got \(error)")
        }
    }
    
    func test_refreshAccessToken_StatusCode400() async {
        let errorResponse = ApiErrorDto(
            error: "invalid_request",
            errorDescription: "Incorrect content type. Must be application/x-www-form-urlencoded"
        )
        let errorData = try! JSONEncoder().encode(errorResponse)
        
        do {
            try keyChain.insert(
                "refresh-token".data(using: .utf8)!,
                identifier: KeyChainTokens.refreshTokenIdentifier,
                service: KeyChainTokens.service
            )
        } catch {
            XCTFail("Could not insert keychain.")
        }
        networkClient.handler.append({ _, _, _ in
            throw NetworkError.badServerResponse(statusCode: 400, data: errorData)
        })
        
        do {
            _ = try await sut.refreshAccessToken()
        } catch let error as ApiError {
            switch error {
            case ApiError.couldNotRefreshToken(let error, let description):
                XCTAssertEqual(errorResponse.error, error)
                XCTAssertEqual(errorResponse.errorDescription, description)
            default: XCTFail("Expected ApiError.badServerResponse, got \(error)")
            }
        } catch {
            XCTFail("Expected ApiError.badServerResponse, got \(error)")
        }
    }
    
    func test_refreshAccessToken_JSONDecodingFails() async {
        do {
            try keyChain.insert(
                "refresh-token".data(using: .utf8)!,
                identifier: KeyChainTokens.refreshTokenIdentifier,
                service: KeyChainTokens.service
            )
        } catch {
            XCTFail("Could not insert keychain.")
        }
        networkClient.handler.append({ _, _, _ in
            return "Some invalid json that should not be accepted".data(using: .utf8)!
        })
        
        do {
            _ = try await sut.refreshAccessToken()
        } catch let error as ApiError {
            switch error {
            case ApiError.dataCorrupted:
                XCTAssertTrue(true)
            default: XCTFail("Expected ApiError.dataCorrupted, got \(error)")
            }
        } catch {
            XCTFail("Expected ApiError.dataCorrupted, got \(error)")
        }
    }
}

