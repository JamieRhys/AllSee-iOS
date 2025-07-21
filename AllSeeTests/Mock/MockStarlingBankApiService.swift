//
//  MockStarlingBankApiService.swift
//  AllSeeTests
//
//  Created by Jamie-Rhys Edwards on 18/07/2025.
//

import Foundation
@testable import AllSee

final class MockStarlingBankApiService2: StarlingBankApiService {
    var fetchAccountsResult: Result<AccountsDto, Error> = .failure(NSError(domain: "unconfigured", code: 0))
    var fetchIndividualInformationResult: Result<IndividualDto, Error> = .failure(NSError(domain: "unconfigured", code: 0))
    var refreshAccessTokenCalled: Bool = false
    
    func fetchAccounts() async throws -> AccountsDto {
        switch fetchAccountsResult {
        case .success(let dto): return dto
        case .failure(let error): throw error
        }
    }
    
    func fetchIndividualInformation() async throws -> IndividualDto {
        switch fetchIndividualInformationResult {
        case .success(let dto): return dto
        case .failure(let error): throw error
        }
    }
    
    func refreshAccessToken() async throws {
        refreshAccessTokenCalled = true
    }
}
