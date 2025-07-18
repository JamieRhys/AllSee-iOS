//
//  IndividualMapperTests.swift
//  AllSeeTests
//
//  Created by Jamie-Rhys Edwards on 18/07/2025.
//

import XCTest
@testable import AllSee

final class IndividualMapperTests: XCTestCase {
/*
 * ==========================================================================
 * Setup and Teardown
 * ==========================================================================
 */
    
    private var sut: IndividualMapper!
    
    override func setUp() {
        sut = IndividualMapper()
    }
    
    override func tearDown() {
        sut = nil
    }
    
/*
 * ==========================================================================
 * To Domain
 * ==========================================================================
 */
    
    func test_toDomain_Success() {
        let expected = Individual(
            title: "Mr",
            firstName: "John",
            lastName: "Doe",
            dob: Date(),
            email: "john.doe@example.com",
            phone: "07900000001"
        )
        guard let dto = try? sut.toDto(from: expected) else {
            XCTFail("Could not convert domain object to DTO")
            return // to satisfy xcode
        }
        
        guard let actual = try? sut.toDomain(from: dto) else {
            XCTFail("Could not convert DTO object to domain.")
            return // to satisfy xcode
        }
        
        XCTAssertEqual(
            expected.title,
            actual.title
        )
        XCTAssertEqual(
            expected.firstName,
            actual.firstName
        )
    }
    
    func test_toDomain_DateParsingErrorBecauseStringIsEmpty() {
        do {
            _ = try sut.toDomain(from:
                IndividualDto(
                    title: "Mr",
                    firstName: "John",
                    lastName: "Doe",
                    dateOfBirth: "",
                    email: "john.doe@example.com",
                    phone: "07900000001"
                )
            )
            
            XCTFail("Expected DateParsingError.invalidDateString to be thrown.")
        } catch let error as DateParsingErrors {
            if error == DateParsingErrors.invalidDateString {
                XCTAssertTrue(true)
            }
        } catch {
            XCTFail("Expected DateParsingError.invalidDateString to be thrown. Got: \(error)")
        }
    }
    
    /*
     * ==========================================================================
     * To DTO
     * ==========================================================================
     */
    
    func test_toDto_Success() {
        let expected = IndividualDto(
            title: "Mr",
            firstName: "John",
            lastName: "Doe",
            dateOfBirth: Date().ISO8601Format(),
            email: "john.doe@example.com",
            phone: "07900000001"
        )
        guard let domain = try? sut.toDomain(from: expected) else {
            XCTFail("Could not convert DTO to domain")
            return // to satisfy xcode
        }
        
        guard let actual = try? sut.toDto(from: domain) else {
            XCTFail("Could not convert domain to DTO")
            return // to satisfy xcode
        }
        
        XCTAssertEqual(
            expected.title,
            actual.title
        )
        XCTAssertEqual(
            expected.firstName,
            actual.firstName
        )
    }
}
