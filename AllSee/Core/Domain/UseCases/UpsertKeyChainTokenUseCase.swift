//
//  UpsertKeyChainTokenUseCase.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 14/07/2025.
//

import Foundation

protocol UpsertKeyChainTokenUseCase {
    func execute(_ token: String, identifier: String, service: String) throws
}

class UpsertKeyChainTokenUseCaseImpl: UpsertKeyChainTokenUseCase {
    func execute(_ token: String, identifier: String, service: String) throws {
        try KeyChain().upsert(
            token.data(using: String.Encoding.utf8)!,
            identifier: identifier,
            service: service
        )
    }
}
