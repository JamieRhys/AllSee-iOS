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
        
        if self.count == 10 {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            if let date = formatter.date(from: self) { return date }
        }
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        if let date = formatter.date(from: self) { return date }
        
        formatter.formatOptions = [.withFractionalSeconds, .withInternetDateTime]
        if let date = formatter.date(from: self) { return date }
        
        throw DateParsingErrors.invalidDateString
    }
}
