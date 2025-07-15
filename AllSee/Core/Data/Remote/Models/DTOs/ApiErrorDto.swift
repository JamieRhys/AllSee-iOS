//
//  ApiErrorDto.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 13/07/2025.
//

import Foundation

struct ApiErrorDto: Codable {
    let error: String
    let errorDescription: String
    
    private enum CodingKeys: String, CodingKey {
        case error
        case errorDescription = "error_description"
    }
}
