//
//  IndividualMapper.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 18/07/2025.
//

import Foundation

class IndividualMapper {
    func toDomain(from dto: IndividualDto) throws -> Individual {
        guard let domain = try? Individual(
            title: dto.title,
            firstName: dto.firstName,
            lastName: dto.lastName,
            dob: dto.dateOfBirth.toDate()!,
            email: dto.email,
            phone: dto.phone
        ) else {
            throw DateParsingErrors.invalidDateString
        }
        
        return domain
    }
    
    func toDto(from domain: Individual) throws -> IndividualDto {
        return IndividualDto(
            title: domain.title,
            firstName: domain.firstName,
            lastName: domain.lastName,
            dateOfBirth: domain.dob.ISO8601Format(),
            email: domain.email,
            phone: domain.phone
        )
    }
}
