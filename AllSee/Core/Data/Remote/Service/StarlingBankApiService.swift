//
//  StarlingBankApiService.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 13/07/2025.
//

import Foundation
import OSLog

protocol StarlingBankApiService {
    // func fetchAccounts() async throws -> AccountsDto
    
    func refreshAccessToken() async throws -> FreshAccessTokenDto
}

final class StarlingBankApiServiceImpl: StarlingBankApiService {
    private let log: Logger
    private let networkClient: NetworkClient
    private let baseUrl = URL(string: "https://api-starlingbank.com/api/v2/")!
    
    init(
        log: Logger,
        networkClient: NetworkClient,
    ) {
        self.log = log
        self.networkClient = networkClient
    }
    
    /*
    func fetchAccounts() async throws -> AccountsDto {
        <#code#>
    }
     */
    
    func refreshAccessToken() async throws -> FreshAccessTokenDto {
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
            
            // 7. Convert data into the DTO and return to caller
            return try decodeJsonData(FreshAccessTokenDto.self, from: data)
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
                }
            default: throw error
            }
            throw error
        } catch DecodingError.dataCorrupted {
            throw ApiError.dataCorrupted
        } catch {
            throw ApiError.unknownError(error)
        }
    }
    
    // Helper functions
    
    private func getToken(identifier: String) throws -> String {
        guard let token = try? KeyChain.getToken(identifier: identifier, service: KeyChainTokens.service) else { throw ApiError.missingToken }
        return token
    }
    
    
    
    private func getAccessToken() throws -> String {
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
