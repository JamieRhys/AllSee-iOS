//
//  String+Extensions.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 18/07/2025.
//

import Foundation

enum DateParsingErrors: Error {
    case invalidDateString
}

extension String {
    /// Converts the given ISO8601 date string into a Date object and returns.
    func toDate() throws -> Date? {
        if self.isEmpty {
            throw DateParsingErrors.invalidDateString
        }
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        if let date = formatter.date(from: self) { return date }
        
        formatter.formatOptions = [.withFractionalSeconds, .withInternetDateTime]
        if let date = formatter.date(from: self) { return date }
        
        throw DateParsingErrors.invalidDateString
    }
}
