//
//  RepositoryErrors.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 18/07/2025.
//

import Foundation

enum RepositoryErrors: Error {
    case cannotMapData
    case unknownError(Error)
}
