//
//  StarlingBankApiServiceTests.swift
//  AllSeeTests
//
//  Created by Jamie-Rhys Edwards on 16/07/2025.
//

@testable import AllSee
import OSLog
import XCTest
import Cuckoo

final class StarlingBankApiServiceTests: XCTestCase {
/*
 * ==========================================================================
 * Setup and Teardown
 * ==========================================================================
 */
    var sut: StarlingBankApiService!
    var mockNetworkClient: MockNetworkClient!
    var mockKeyChain: MockKeyChainStorable!
    var log: Logger!
    
    private let accessToken = "access-token"
    
    override func setUp() {
        super.setUp()
        
        mockNetworkClient = MockNetworkClient()
        mockKeyChain = MockKeyChainStorable()
        log = Logger()
        
        sut = StarlingBankApiServiceImpl(
            keyChain: mockKeyChain,
            log: log,
            networkClient: mockNetworkClient,
        )
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
        mockNetworkClient = nil
        mockKeyChain = nil
        log = nil
    }
    
/*
 * ==========================================================================
 * Fetch Accounts
 * ==========================================================================
 */
    
    func test_fetchAccounts_Success() async {
        
        let expected = AccountsDto(
            accounts: [
                AccountDto(
                    accountUid: "some-uid",
                    accountType: "some-account-type",
                    defaultCategory: "some-default-category",
                    currency: "GBP",
                    createdAt: "2025-07-17",
                    name: "Personal"
                )
            ]
        )
        
        stub(mockKeyChain) { stub in
            when(stub.get(identifier: any(), service: any())).thenReturn(accessToken)
        }
        
        stub(mockNetworkClient) { stub in
            when(stub.get(from: any(), headers: any()))
                .thenReturn(try! JSONEncoder().encode(expected))
        }
        
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
        
        let errorResponse = ApiErrorDto(
            error: "invalid_token",
            errorDescription: "Unable to validate token. Might it be expired?"
        )
        let errorData = try! JSONEncoder().encode(errorResponse)
        
        stub(mockKeyChain) { stub in
            when(stub.get(identifier: any(), service: any())).thenReturn(accessToken).thenReturn(accessToken)
            when(stub.upsert(any(), identifier: any(), service: any())).thenDoNothing()
        }
        
        stub(mockNetworkClient) { stub in
            when(stub.get(from: any(), headers: any()))
                .thenThrow(NetworkError.badServerResponse(statusCode: 403, data: errorData))
                .thenReturn(try! JSONEncoder().encode(expected))
            
            when(stub.post(to: any(), headers: any(), components: any()))
                .thenReturn(try! JSONEncoder().encode(freshToken))
        }
        
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
        let errorResponse = ApiErrorDto(
            error: "unknown_error",
            errorDescription: "",
        )
        
        stub(mockKeyChain) { stub in
            stub.get(identifier: any(), service: any()).thenReturn("access-token")
        }
        
        stub(mockNetworkClient) { stub in
            stub.get(from: any(), headers: any()).thenThrow(
                NetworkError.badServerResponse(
                    statusCode: 404,
                    data: try! JSONEncoder().encode(errorResponse)
                )
            )
        }
        
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
    
    func test_fetchAccounts_NetworkError() async {
        stub(mockKeyChain) { stub in
            stub.get(identifier: any(), service: any()).thenReturn("access_token")
        }
        
        stub(mockNetworkClient) { stub in
            stub.get(from: any(), headers: any()).thenThrow(
                NetworkError.requestTimedOut
            )
        }
        
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
    
    func test_fetchAccounts_JsonDecodeFailureWhenDecodingReturnedData() async {
        stub(mockKeyChain) { stub in
            stub.get(identifier: any(), service: any()).thenReturn("access_token")
        }
        
        stub(mockNetworkClient) { stub in
            stub.get(from: any(), headers: any()).thenThrow(
                ApiError.dataCorrupted
            )
        }
        
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
    
/*
 * ==========================================================================
 * Fetch Account Holder
 * ==========================================================================
 */
    
    func test_fetchAccountHolder_Success() async {
        let expected = AccountHolderDto(
            accountHolderUid: UUID().uuidString,
            accountHolderType: "INDIVIDUAL"
        )
        
        stub(mockKeyChain) { stub in
            stub.get(identifier: any(), service: any()).thenReturn("access_token")
        }
        
        stub(mockNetworkClient) { stub in
            stub.get(from: any(), headers: any()).thenReturn(try! JSONEncoder().encode(expected))
        }
        
        guard let actual = try? await sut.fetchAccountHolder() else {
            XCTFail("Failed to fetch account holder")
            return // to satisfy xcode
        }
        
        XCTAssertEqual(expected.accountHolderUid, actual.accountHolderUid)
        XCTAssertEqual(expected.accountHolderType, actual.accountHolderType)
    }
    
    func test_fetchAccountHolder_whenApiErrorThrown_thenFunctionPassesToCaller() async {
        stub(mockKeyChain) { stub in
            stub.get(identifier: any(), service: any()).thenThrow(ApiError.missingAccessToken)
        }
        
        do {
            _ = try await sut.fetchAccountHolder()
            XCTFail("Expected an ApiError.missingAccessToken to be thrown here.")
        } catch let error as ApiError {
            switch error {
            case ApiError.missingAccessToken: XCTAssertTrue(true)
            default: XCTFail("Expected an ApiError.missingAccessToken to be thrown here. Got: \(error)")
            }
        } catch {
            XCTFail("Expected an ApiError.missingAccessToken to be thrown here. Got: \(error)")
        }
    }
    
    func test_fetchAccountHolder_whenBadServerResponse403Thrown_thenRefreshOfTokenIsAttempted() async {
        let freshToken = FreshAccessTokenDto(
            access_token: "fresh_access-token",
            refresh_token: "fresh_refresh-token",
            token_type: "refresh-token",
            expires_in: 3600,
            scope: "bunch; of; different; scopes;"
        )
        let errorResponse = ApiErrorDto(
            error: "invalid_token",
            errorDescription: "Unable to validate provided token"
        )
        let expected = AccountHolderDto(
            accountHolderUid: UUID().uuidString,
            accountHolderType: "INDIVIDUAL"
        )
        
        stub(mockKeyChain) { stub in
            stub.get(identifier: any(), service: any()).thenReturn(accessToken).thenReturn(accessToken)
            stub.upsert(any(), identifier: any(), service: any()).thenDoNothing()
        }
        
        stub(mockNetworkClient) { stub in
            stub.get(from: any(), headers: any())
                .thenThrow(NetworkError.badServerResponse(statusCode: 403, data: try! JSONEncoder().encode(errorResponse)))
                .thenReturn(try! JSONEncoder().encode(expected))
            
            stub.post(to: any(), headers: any(), components: any())
                .thenReturn(try! JSONEncoder().encode(freshToken))
        }
        
        do {
            let actual = try await sut.fetchAccountHolder()
            
            XCTAssertEqual(expected.accountHolderUid, actual.accountHolderUid)
            XCTAssertEqual(expected.accountHolderType, actual.accountHolderType)
        } catch {
            XCTFail("Pass expected here. Got: \(error)")
        }
    }
    
    func test_fetchAccountHolder_whenInvalidServerResponseThrown_thenFunctionCorrectlyHandlesError() async {
        let errorResponse = ApiErrorDto(
            error: "not_found",
            errorDescription: "Page not found!"
        )
        
        stub(mockKeyChain) { stub in
            stub.get(identifier: any(), service: any()).thenReturn("access_token")
        }
        
        stub(mockNetworkClient) { stub in
            stub.get(from: any(), headers: any()).thenThrow(
                NetworkError.badServerResponse(statusCode: 404, data: try! JSONEncoder().encode(errorResponse))
            )
        }
        
        do {
            _ = try await sut.fetchAccountHolder()
            XCTFail("Expected to fail here.")
        } catch let error as ApiError {
            switch error {
            case ApiError.invalidResponse: XCTAssertTrue(true)
            default: XCTFail("Expected ApiError.invalidResponse to be thrown. Got: \(error)")
            }
        } catch {
            XCTFail("Expected ApiError.invalidResponse to be thrown. Got: \(error)")
        }
    }
    
/*
 * ==========================================================================
 * Refresh Access Token
 * ==========================================================================
 */
    func test_fetchIndividualInformation_Success() async {
        let expected = IndividualDto(
            title: "Mr",
            firstName: "Joe",
            lastName: "Bloggs",
            dateOfBirth: "1975-01-01",
            email: "joe.bloggs@example.com",
            phone: "079000000001"
        )
        
        stub(mockKeyChain) { stub in
            stub.get(identifier: any(), service: any()).thenReturn("access_token")
        }
        
        stub(mockNetworkClient) { stub in
            stub.get(from: any(), headers: any()).thenReturn(try! JSONEncoder().encode(expected))
        }
        
        guard let actual = try? await sut.fetchIndividualInformation() else {
            XCTFail("Failed to fetch individual information")
            return // to satisfy xcode
        }
        
        XCTAssertEqual(expected.title, actual.title)
        XCTAssertEqual(expected.firstName, actual.firstName)
    }
    
    func test_fetchIndividualInformation_MissingAccessToken() async {
        let freshToken = FreshAccessTokenDto(
            access_token: "fresh_access-token",
            refresh_token: "fresh_refresh-token",
            token_type: "refresh-token",
            expires_in: 3600,
            scope: "bunch; of; different; scopes;"
        )
        
        let expected = IndividualDto(
            title: "Mr",
            firstName: "Joe",
            lastName: "Bloggs",
            dateOfBirth: "1975-01-01",
            email: "joe.bloggs@example.com",
            phone: "079000000001"
        )
        let errorResponse = ApiErrorDto(
            error: "invalid_token",
            errorDescription: "Unable to validate token. Might it be expired?"
        )
        
        stub(mockKeyChain) { stub in
            stub.get(identifier: any(), service: any()).thenReturn("access_token")
            stub.upsert(any(), identifier: any(), service: any()).thenDoNothing()
        }
        
        stub(mockNetworkClient) { stub in
            stub.get(from: any(), headers: any())
                .thenThrow(NetworkError.badServerResponse(statusCode: 403, data: try! JSONEncoder().encode(errorResponse)))
                .thenReturn(try! JSONEncoder().encode(expected))
            
            stub.post(to: any(), headers: any(), components: any()).thenReturn(try! JSONEncoder().encode(freshToken))
        }
        
        do {
            let actual = try await sut.fetchIndividualInformation()
            
            XCTAssertEqual(
                expected.title,
                actual.title
            )
            XCTAssertEqual(
                expected.firstName,
                actual.firstName
            )
        } catch {
            XCTFail("Expected to pass. Got \(error)")
        }
    }
    
    func test_fetchIndividualInformation_UnknownBadServerResponse() async {
        let errorResponse = ApiErrorDto(
            error: "unknown_error",
            errorDescription: "",
        )
        
        stub(mockKeyChain) { stub in
            stub.get(identifier: any(), service: any()).thenReturn("access_token")
        }
        
        stub(mockNetworkClient) { stub in
            stub.get(from: any(), headers: any()).thenThrow(NetworkError.badServerResponse(statusCode: 404, data: try! JSONEncoder().encode(errorResponse)))
        }
        
        do {
            _ = try await sut.fetchIndividualInformation()
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
    
    func test_fetchIndividualInformation_NetworkError() async {
        stub(mockKeyChain) { stub in
            stub.get(identifier: any(), service: any()).thenReturn("access_token")
        }
        
        stub(mockNetworkClient) { stub in
            stub.get(from: any(), headers: any()).thenThrow(NetworkError.requestTimedOut)
        }
        
        do {
            _ = try await sut.fetchIndividualInformation()
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
    
    func test_fetchIndividualInformation_JsonDecodeFailureWhenDecodingReturnedData() async {
        stub(mockKeyChain) { stub in
            stub.get(identifier: any(), service: any()).thenReturn("access_token")
        }
        
        stub(mockNetworkClient) { stub in
            stub.get(from: any(), headers: any()).thenThrow(ApiError.dataCorrupted)
        }
        
        do {
            _ = try await sut.fetchIndividualInformation()
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
        
        stub(mockKeyChain) { stub in
            stub.get(identifier: equal(to: KeyChainTokens.refreshTokenIdentifier), service: equal(to: KeyChainTokens.service))
                .thenReturn("refresh_token")
            
            stub.upsert(any(), identifier: any(), service: any()).thenDoNothing()
        }
        
        stub(mockNetworkClient) { stub in
            stub.post(to: any(), headers: any(), components: any())
                .thenReturn(try! JSONEncoder().encode(expected))
        }
        
        do {
            try await sut.refreshAccessToken()
        } catch {
            XCTFail("Unexpected error. Got: \(error)")
        }
        
        verify(mockKeyChain).upsert(equal(to: expected.access_token.data(using: .utf8)!), identifier: equal(to: KeyChainTokens.accessTokenIdentifier), service: equal(to: KeyChainTokens.service))
        verify(mockKeyChain).upsert(equal(to: expected.refresh_token.data(using: .utf8)!), identifier: equal(to: KeyChainTokens.refreshTokenIdentifier), service: equal(to: KeyChainTokens.service))
    }
    
    func test_refreshAccessToken_MissingRefreshToken() async {
        stub(mockKeyChain) { stub in
            stub.get(identifier: equal(to: KeyChainTokens.refreshTokenIdentifier), service: equal(to: KeyChainTokens.service)).thenReturn("")
        }
        
        stub(mockNetworkClient) { stub in
            stub.post(to: any(), headers: any(), components: any()).thenThrow(ApiError.missingRefreshToken)
        }
        
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
        stub(mockKeyChain) { stub in
            stub.get(identifier: any(), service: any()).thenReturn("access-token")
        }
        
        stub(mockNetworkClient) { stub in
            stub.post(to: any(), headers: any(), components: any()).thenThrow(NetworkError.requestTimedOut)
        }
        
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
        
        stub(mockKeyChain) { stub in
            stub.get(identifier: equal(to: KeyChainTokens.refreshTokenIdentifier), service: equal(to: KeyChainTokens.service)).thenReturn("refresh_token")
        }
        
        stub(mockNetworkClient) { stub in
            stub.post(to: any(), headers: any(), components: any()).thenThrow(
                NetworkError.badServerResponse(
                    statusCode: 400,
                    data: try! JSONEncoder().encode(errorResponse)
                )
            )
        }
        
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
        stub(mockKeyChain) { stub in
            stub.get(identifier: equal(to: KeyChainTokens.refreshTokenIdentifier), service: KeyChainTokens.service).thenReturn("refresh_token")
        }
        
        stub(mockNetworkClient) { stub in
            stub.post(to: any(), headers: any(), components: any()).thenThrow(ApiError.dataCorrupted)
        }
        
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
