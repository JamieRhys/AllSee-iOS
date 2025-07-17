//
//  StarlingBankApiService.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 13/07/2025.
//

import Foundation
import OSLog

protocol StarlingBankApiService {
    func fetchAccounts() async throws -> AccountsDto
    
    func fetchIndividualInformation() async throws -> IndividualDto
    
    func refreshAccessToken() async throws
}

final class StarlingBankApiServiceImpl: StarlingBankApiService {
    private let keyChain: KeyChainStorable
    private let log: Logger
    private let networkClient: NetworkClient
    private let baseUrl = URL(string: "https://api-starlingbank.com/api/v2/")!
    
    init(
        keyChain: KeyChainStorable,
        log: Logger,
        networkClient: NetworkClient,
    ) {
        self.keyChain = keyChain
        self.log = log
        self.networkClient = networkClient
    }
    
    
    func fetchAccounts() async throws -> AccountsDto {
        do {
            let token = try await getAccessToken()
            let url = baseUrl.appendingPathComponent("accounts")
            let data = try await networkClient.get(
                from: url,
                headers: ["Authorization": "Bearer \(token)"]
            )
            
            return try decodeJsonData(AccountsDto.self, from: data)
        } catch let error as ApiError {
            throw error
        } catch let error as NetworkError {
            switch error {
            case .badServerResponse(let code, let data):
                if code == 403, let data = data {
                    let apiError = try? decodeJsonData(ApiErrorDto.self, from: data)
                    
                    if apiError?.error == "invalid_token" {
                        try await refreshAccessToken()
                        return try await fetchAccounts()
                    }
                } else {
                    throw ApiError.invalidResponse(error)
                }
            default:
                throw ApiError.invalidResponse(error)
            }
            
            throw ApiError.unknownError(error)
        } catch DecodingError.dataCorrupted {
            throw ApiError.dataCorrupted
        } catch {
            throw ApiError.unknownError(error)
        }
    }
    
    func fetchIndividualInformation() async throws -> IndividualDto {
        do {
            let token = try await getAccessToken()
            let url = baseUrl.appendingPathComponent("account-holder/individual")
            let data = try await networkClient.get(
                from: url,
                headers: ["Authorization": "Bearer \(token)"]
            )
            
            return try decodeJsonData(IndividualDto.self, from: data)
        } catch let error as ApiError {
            throw error
        } catch let error as NetworkError {
            switch error {
            case .badServerResponse(let code, let data):
                if code == 403, let data = data {
                    let apiError = try? decodeJsonData(ApiErrorDto.self, from: data)
                    
                    if apiError?.error == "invalid_token" {
                        try await refreshAccessToken()
                        return try await fetchIndividualInformation()
                    }
                } else {
                    throw ApiError.invalidResponse(error)
                }
            default:
                throw ApiError.invalidResponse(error)
            }
            
            throw ApiError.unknownError(error)
        } catch DecodingError.dataCorrupted {
            throw ApiError.dataCorrupted
        } catch {
            throw ApiError.unknownError(error)
        }
    }
    
    func refreshAccessToken() async throws {
        do {
            // 1. Get the refresh token from the keychain.
            let refreshToken = try getRefreshToken()
            
            // 2. Construct the JSON string and convert to utf8 Data type.
            var components = URLComponents()
            components.queryItems = [
                URLQueryItem(name: "refresh_token", value: refreshToken),
                URLQueryItem(name: "client_id", value: StarlingBankApiSecrets.ClientID),
                URLQueryItem(name: "client_secret", value: StarlingBankApiSecrets.ClientSecret),
                URLQueryItem(name: "grant_type", value: "refresh_token")
            ]
            
            // 3. Construct URL object
            let url = URL(string: "https://api-sandbox.starlingbank.com/oauth/access-token")!
            let headers = ["Content-Type" : "application/x-www-form-urlencoded"]
            
            // 4. Send request and wait for response. If this fails, it will trigger the catch below.
            let data = try await networkClient.post(to: url, headers: headers, components: components)
            
            // 7. Convert data into the DTO
            let dto = try decodeJsonData(FreshAccessTokenDto.self, from: data)
            
            // 8. Convert access token and refresh token into a data format
            guard let accessToken = dto.access_token.data(using: .utf8) else { throw ApiError.couldNotRefreshToken("invalid_access_token", "Could not convert access token to data") }
            guard let refreshToken = dto.refresh_token.data(using: .utf8) else { throw ApiError.couldNotRefreshToken("invalid_refresh_token", "Could not convert refresh token to data") }
            
            // 9. Upsert both the access and refresh tokens into the keychain.
            try keyChain.upsert(accessToken, identifier: KeyChainTokens.accessTokenIdentifier, service: KeyChainTokens.service)
            try keyChain.upsert(refreshToken, identifier: KeyChainTokens.refreshTokenIdentifier, service: KeyChainTokens.service)
        } catch let error as ApiError {
            switch error {
            default:
                throw error
            }
        } catch let error as NetworkError {
            switch error {
            case .badServerResponse(let code, let data):
                if code == 400, let data = data {
                    let apiError = try? decodeJsonData(ApiErrorDto.self, from: data)
                    log.error("[StarlingBankApiServiceImpl - refreshAccessToken] Api Error: \(String(describing: apiError?.error)) - \(apiError?.errorDescription ?? "No description")")
                    throw ApiError.couldNotRefreshToken(apiError?.error ?? "unknown_error", apiError?.errorDescription ?? "unknown_description")
                }
            default: throw ApiError.invalidResponse(error)
            }
            throw ApiError.unknownError(error)
        } catch DecodingError.dataCorrupted {
            throw ApiError.dataCorrupted
        } catch {
            throw ApiError.unknownError(error)
        }
    }
    
    // Helper functions
    
    private func getToken(identifier: String) throws -> String {
        guard let token = try? keyChain.get(identifier: identifier, service: KeyChainTokens.service) else { throw ApiError.missingToken } // TODO: Replace with use case instead.
        return token
    }
    
    private func getAccessToken() async throws -> String {
        do {
            return try getToken(identifier: KeyChainTokens.accessTokenIdentifier)
        } catch let error as ApiError {
            switch error {
            case ApiError.missingToken: throw ApiError.missingAccessToken
            default: throw error
            }
        }
    }
    
    private func getRefreshToken() throws -> String {
        do {
            return try getToken(identifier: KeyChainTokens.refreshTokenIdentifier)
        } catch let error as ApiError {
            switch error {
            case ApiError.missingToken: throw ApiError.missingRefreshToken
            default: throw error
            }
        }
    }
    
    private func decodeJsonData<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        return try JSONDecoder().decode(type, from: data)
    }
}
