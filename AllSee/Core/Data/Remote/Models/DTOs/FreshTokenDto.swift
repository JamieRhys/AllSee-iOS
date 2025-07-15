//
//  FreshTokenDto.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 13/07/2025.
//

import Foundation

struct FreshAccessTokenDto : Codable {
    let access_token: String
    let refresh_token: String
    let token_type: String
    let expires_in: Int
    let scope: String
}
