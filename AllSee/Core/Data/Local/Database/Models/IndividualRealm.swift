//
//  IndividualRealm.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 21/07/2025.
//

import Foundation
import RealmSwift

final class IndividualRealm: Object {
    @Persisted(primaryKey: true) var accountHolderUid: UUID
    @Persisted var title: String
    @Persisted var firstName: String
    @Persisted var lastName: String
    @Persisted var dob: String
    @Persisted var email: String
    @Persisted var phone: String
    @Persisted var accountHolderType: String
}
