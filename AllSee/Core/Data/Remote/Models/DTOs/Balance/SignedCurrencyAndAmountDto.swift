//
//  SignedCurrencyAndAmountDto.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 13/07/2025.
//

import Foundation

/// Represents the currency amount as well as the currency type.
struct SignedCurrencyAndAmountDto : Codable {
    let currency: String
    let minorUnits: Int
}
