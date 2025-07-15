//
//  GetKeyChainTokenUseCase.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 14/07/2025.
//

import Foundation

protocol GetKeyChainTokenUseCase {
    func execute(_ identifier: String, service: String) throws -> String
}

class GetKeyChainTokenUseCaseImpl: GetKeyChainTokenUseCase {
    func execute(_ identifier: String, service: String) throws -> String {
        return try KeyChain().get(identifier: identifier, service: service)
    }
}
