//
//  UpsertKeyChainTokenUseCase.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 14/07/2025.
//

import Foundation

protocol UpsertKeyChainTokenuseCase {
    func execute(_ token: String, identifier: String, service: String) throws
}

class UpsertKeyChainTokenUseCaseImpl: UpsertKeyChainTokenuseCase {
    func execute(_ token: String, identifier: String, service: String) throws {
        try KeyChain.upsertToken(
            token.data(using: String.Encoding.utf8)!,
            identifier: identifier,
            service: service
        )
    }
}
