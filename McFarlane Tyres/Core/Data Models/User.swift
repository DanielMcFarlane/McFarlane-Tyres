//
//  User.swift
//  McFarlane Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//

import Foundation
import SwiftData

@Model
class User: Identifiable {
    @Attribute(.unique) var id: UUID
    var email: String
    var password: String
    var loggedIn: Bool
    var isAdmin: Bool
    var isStaff: Bool

    init(id: UUID = UUID(), email: String, password: String, loggedIn: Bool = false, isAdmin: Bool = false, isStaff: Bool = false) {
        self.id = id
        self.email = email
        self.password = password
        self.loggedIn = loggedIn
        self.isAdmin = isAdmin
        self.isStaff = isStaff
    }
}
