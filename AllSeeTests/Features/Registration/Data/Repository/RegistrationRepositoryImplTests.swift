//
//  RegistrationRepositoryImplTests.swift
//  AllSeeTests
//
//  Created by Jamie-Rhys Edwards on 18/07/2025.
//

import Foundation

import XCTest
import OSLog
@testable import AllSee

final class RegistrationRepositoryImplTests: XCTestCase {
/*
/*
 * ==========================================================================
 * Setup and Teardown
 * ==========================================================================
 */
    
    var sut: RegistrationRepository!
    var apiService: StarlingBankApiService!
    var individualMapper: IndividualMapper!
    var keyChain: KeyChainStorable!
    
    override func setUp() {
        super.setUp()
        
        keyChain = MockKeyChain()
        apiService = MockStarlingBankApiService()
        
        sut = RegistrationRepositoryImpl(
            apiService: apiService,
            individualMapper: IndividualMapper(),
            upsertKeyChainTokenUseCase: UpsertKeyChainTokenUseCaseImpl(),
        )
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
/*
 * ==========================================================================
 * Fetch Individual Information
 * ==========================================================================
 */
    
    // TODO: Happy path - The function returns a success result with the DTO.
    
    func test_fetchIndividualInformation_Success() async throws {
        do {
            try keyChain.insert(
                "access-token".data(using: .utf8)!,
                identifier: KeyChainTokens.accessTokenIdentifier,
                service: KeyChainTokens.service
            )
        } catch {
            XCTFail("Could not insert keychain.")
        }
        
        let expected = Individual(
            title: "Mr",
            firstName: "Joe",
            lastName: "Bloggs",
            dob: Date(),
            email: "joe.bloggs@example.com",
            phone: "07900000001"
        )
        
        
    }
    
    // TODO: Date Parsing Error - The function returns a failure with date parsing error
    
    
    
    // TODO: General failure - The function returns a failure when all other error types are thrown.
*/
}
