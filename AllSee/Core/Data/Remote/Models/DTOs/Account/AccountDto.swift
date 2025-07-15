//
//  AccountDto.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 13/07/2025.
//

import Foundation

struct AccountDto: Codable {
    let accountUid: String
    let accountType: String
    let defaultCategory: String
    let currency: String
    let createdAt: String
    let name: String
}
