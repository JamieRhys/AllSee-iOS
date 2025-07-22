//
//  RegistrationRepository.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 18/07/2025.
//

import Foundation
import RealmSwift

final class RegistrationRepositoryImpl: RegistrationRepository {
    private let apiService: StarlingBankApiService
    private let individualMapper: IndividualMapper 
    private let upsertKeyChainTokenUseCase: UpsertKeyChainTokenUseCase
    
    init(
        apiService: StarlingBankApiService,
        individualMapper: IndividualMapper,
        upsertKeyChainTokenUseCase: UpsertKeyChainTokenUseCase
    ) {
        self.apiService = apiService
        self.individualMapper = individualMapper
        self.upsertKeyChainTokenUseCase = upsertKeyChainTokenUseCase
    }
    
    func fetchIndividualInformation(completion: @escaping (Result<Individual, any Error>) -> Void) async throws {
        do {
            let dto = try await apiService.fetchIndividualInformation()
            
            completion(.success(try individualMapper.toDomain(from: dto)))
        } catch is DateParsingErrors {
            completion(.failure(RepositoryErrors.cannotMapData))
        } catch {
            completion(.failure(RepositoryErrors.unknownError(error)))
        }
    }
    
    /*
    func saveAccessAndRefreshTokens(accessToken: String, refreshToken: String) throws {
        <#code#>
    }
    */
}
