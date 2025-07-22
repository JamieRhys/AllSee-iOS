//
//  RegistrationRepository.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 17/07/2025.
//

import Foundation

protocol RegistrationRepository {
    
    func fetchIndividualInformation(completion: @escaping (Result<Individual, Error>) -> Void) async throws
    
    func saveAccessAndRefreshTokens(accessToken: String, refreshToken: String) throws
}
