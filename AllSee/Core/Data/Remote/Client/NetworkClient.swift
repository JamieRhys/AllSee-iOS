//
//  NetworkClient.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 13/07/2025.
//

import Foundation
import OSLog

final class NetworkClient {
    private let session: URLSession
    private let log: Logger
    
    init(
        session: URLSession = .shared,
        log: Logger,
    ) {
        self.session = session
        self.log = log
    }
    
    func get(from url: URL, headers: [String : String]? = nil) async throws -> Data {
        do {
            // Create everything needed to make the request from an API.
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
            
            // Make the request from the given API.
            let (data, response) = try await session.data(for: request)
            // Validate the response and if correct, return back data.
            try validateResponse(response, data: data)
            return data
        } catch let urlError as URLError {
            switch urlError {
            case URLError.timedOut:
                log.error("[NetworkClient] Request timed out.")
                throw NetworkError.requestTimedOut
            case URLError.notConnectedToInternet:
                log.error("[NetworkClient] Not connected to the internet.")
                throw NetworkError.notConnectedToTheInternet
            case URLError.badURL, URLError.unsupportedURL:
                log.error("[NetworkClient] Invalid or unsupported URL: \(url)")
                throw NetworkError.invalidUrl
            default:
                log.error("[NetworkClient] Unknown Error: \(urlError)")
                throw NetworkError.unknownError(urlError)
            }
        } catch let error as NetworkError {
            log.error("[NetworkClient] Uncaught Network Error: \(error)")
            throw error
        } catch {
            log.error("[NetworkClient] Unknown Error: \(error)")
            throw NetworkError.unknownError(error)
        }
    }
    
    func post(to url: URL, headers: [String : String]? = nil, components: URLComponents) async throws -> Data {
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
            request.httpBody = components.query?.data(using: .utf8)
            
            let (data, response) = try await session.data(for: request)
            try validateResponse(response, data: data)
            return data
        } catch let urlError as URLError {
            switch urlError {
            case URLError.timedOut:
                log.error("[NetworkClient] Request timed out.")
                throw NetworkError.requestTimedOut
            case URLError.notConnectedToInternet:
                log.error("[NetworkClient] Not connected to the internet.")
                throw NetworkError.notConnectedToTheInternet
            case URLError.badURL, URLError.unsupportedURL:
                log.error("[NetworkClient] Invalid or unsupported URL: \(url)")
                throw NetworkError.invalidUrl
            default:
                log.error("[NetworkClient] Unknown Error: \(urlError)")
                throw NetworkError.unknownError(urlError)
            }
        } catch let error as NetworkError {
            log.error("[NetworkClient] Network Error: \(error)")
            throw error
        } catch {
            log.error("[NetworkClient] Unknown Error: \(error)")
            throw NetworkError.unknownError(error)
        }
    }
    
    private func validateResponse(_ response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.badServerResponse(statusCode: -1)
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.badServerResponse(statusCode: httpResponse.statusCode, data: data)
        }
    }
}
