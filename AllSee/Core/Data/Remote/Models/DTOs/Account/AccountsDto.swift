//
//  AccountsDto.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 13/07/2025.
//

import Foundation

/// Represents the accounts held by an account holder.
struct AccountsDto: Codable {
    let accounts: [AccountDto]
}
