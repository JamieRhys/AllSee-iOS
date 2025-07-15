//
//  BalanceDto.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 13/07/2025.
//

import Foundation

struct BalanceDto : Codable {
    let clearedBalance: SignedCurrencyAndAmountDto
    let effectiveBalance: SignedCurrencyAndAmountDto
    let pendingTransactions: SignedCurrencyAndAmountDto
    let acceptedOverdraft: SignedCurrencyAndAmountDto
    let amount: SignedCurrencyAndAmountDto
    let totalClearedBalance: SignedCurrencyAndAmountDto
    let totalEffectiveBalance: SignedCurrencyAndAmountDto
}
