//
//  NetworkError.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 13/07/2025.
//

import Foundation

/// Holds the different types of network errors that can occur in the network client at any time a request is made.
enum NetworkError: Error {
    
    case requestTimedOut
    case invalidUrl
    case notConnectedToTheInternet
    case badServerResponse(statusCode: Int, data: Data? = nil)
    case unknownError(Error)
}
