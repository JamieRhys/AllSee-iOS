//
//  RegistrationRepositoryImplTests.swift
//  AllSeeTests
//
//  Created by Jamie-Rhys Edwards on 18/07/2025.
//

import Foundation

import Cuckoo
import XCTest
import OSLog
@testable import AllSee

final class RegistrationRepositoryImplTests: XCTestCase {
/*
 * ==========================================================================
 * Setup and Teardown
 * ==========================================================================
 */
    
    var sut: RegistrationRepository!
    var mockApiService: MockStarlingBankApiService!
    var individualMapper: IndividualMapper!
    var mockUpsertKeyChainTokenUseCase: MockUpsertKeyChainTokenUseCase!
    
    override func setUp() {
        mockApiService = MockStarlingBankApiService()
        individualMapper = IndividualMapper()
        mockUpsertKeyChainTokenUseCase = MockUpsertKeyChainTokenUseCase()
        sut = RegistrationRepositoryImpl(
            apiService: mockApiService,
            individualMapper: individualMapper,
            upsertKeyChainTokenUseCase: mockUpsertKeyChainTokenUseCase
        )
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
        mockApiService = nil
        individualMapper = nil
        mockUpsertKeyChainTokenUseCase = nil
    }
    
/*
 * ==========================================================================
 * Fetch Individual Information
 * ==========================================================================
 */
        
    func test_fetchIndividualInformation_Success() async {
        let expectedDto = IndividualDto(
            title: "Mr",
            firstName: "Joe",
            lastName: "Bloggs",
            dateOfBirth: Date.now.ISO8601Format(),
            email: "joe.bloggs@example.com",
            phone: "07908000001"
        )
        let expected = try! individualMapper.toDomain(from: expectedDto)
        
        stub(mockApiService) { stub in
            stub.fetchIndividualInformation().thenReturn(expectedDto)
        }
        
        do {
            try await sut.fetchIndividualInformation(completion: { result in
                switch result {
                case .success(let actual):
                    XCTAssertEqual(expected.title, actual.title)
                    XCTAssertEqual(expected.firstName, actual.firstName)
                case .failure(let error): XCTFail("Pass was expected. Got \(error)")
                }
            })
        } catch {
            XCTFail("Pass was expected. Got \(error)")
        }
    }
    
    func test_fetchIndividualInformation_whenDateParsingErrorThrown_thenCannotMapDataErrorReturned() async {
        let invalidDto = IndividualDto(
            title: "Mr",
            firstName: "Joe",
            lastName: "Bloggs",
            dateOfBirth: "Invalid_json",
            email: "joe.bloggs@exampl.com",
            phone: "07908000001"
        )
        
        stub(mockApiService) { stub in
            stub.fetchIndividualInformation().thenReturn(invalidDto)
        }
        
        do {
            try await sut.fetchIndividualInformation(completion: { result in
                switch result {
                case .success: XCTFail("Expected a fail here.")
                case .failure(let error as RepositoryErrors):
                    switch error {
                    case RepositoryErrors.cannotMapData: XCTAssertTrue(true)
                    default: XCTFail("Expected RepositoryErrors.cannotMapData error to be thrown")
                    }
                default: XCTFail("Expected RepositoryErrors.cannotMapData error to be thrown")
                }
            })
        } catch {
            XCTFail("Expected RepositoryErrors.cannotMapData error to be thrown. Got \(error)")
        }
    }
    
    func test_fetchIndividualInformation_whenGeneralUnknownErrorThrown_thenRepositoryUnknownErrorReturned() async {
        stub(mockApiService) { stub in
            stub.fetchIndividualInformation().thenThrow(ApiError.missingAccessToken)
        }
        
        do {
            try await sut.fetchIndividualInformation(completion: { result in
                switch result {
                case .success: XCTFail("Expected RepositoryErrors.unknownError to be thrown")
                case .failure(let error as RepositoryErrors):
                    switch error {
                    case RepositoryErrors.unknownError: XCTAssertTrue(true)
                    default: XCTFail("Expected RepositoryErrors.unknownError to be thrown")
                    }
                default: XCTFail("Expected RepositoryErrors.unknownError to be thrown")
                }
            })
        } catch {
            XCTFail("Expected RepositoryErrors.unknownError to be thrown. Got: \(error)")
        }
    }
}
