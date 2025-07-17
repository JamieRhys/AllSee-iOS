//
//  ApiError.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 13/07/2025.
//

import Foundation

/// Holds the different types of API errors that can occur when making a request to the API client.
enum ApiError: Error {
    case missingAccessToken
    case missingRefreshToken
    case missingToken
    case invalidToken
    case invalidResponse(Error)
    case dataCorrupted
    case couldNotRefreshToken(String, String)
    case unknownError(Error)
}
