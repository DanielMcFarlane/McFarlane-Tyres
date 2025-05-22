//
//  DefaultUserData.swift
//  McFarlane Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  Contains default user data including email, password and admin status.
//

import Foundation

// A struct is used to hold default user data
struct DefaultUserData {
    let email: String
    let password: String
    let isAdmin: Bool
    let isStaff: Bool
}

let defaultUsers: [DefaultUserData] = [
    DefaultUserData(email: "admin", password: "password", isAdmin: true, isStaff: true),
    DefaultUserData(email: "staff1", password: "password", isAdmin: false, isStaff: true),
    DefaultUserData(email: "staff2", password: "password", isAdmin: false, isStaff: true),
    DefaultUserData(email: "staff3", password: "password", isAdmin: false, isStaff: true),
    DefaultUserData(email: "cust1", password: "password", isAdmin: false, isStaff: false),
    DefaultUserData(email: "cust2", password: "password", isAdmin: false, isStaff: false),
    DefaultUserData(email: "cust3", password: "password", isAdmin: false, isStaff: false),

    DefaultUserData(email: "daniel.mcfarlane@gmail.com", password: "password", isAdmin: false, isStaff: false),
    DefaultUserData(email: "jordan.ellis@yahoo.co.uk", password: "password", isAdmin: false, isStaff: false),
    DefaultUserData(email: "abdullah.atiya@outlook.com", password: "password", isAdmin: false, isStaff: false),
    DefaultUserData(email: "michelle.blair@hotmail.com", password: "password", isAdmin: false, isStaff: false),
    DefaultUserData(email: "martin.barrett@icloud.com", password: "password", isAdmin: false, isStaff: false),
    DefaultUserData(email: "jude.nelson@gmail.com", password: "password", isAdmin: false, isStaff: false),
    DefaultUserData(email: "amanda.ford@yahoo.co.uk", password: "password", isAdmin: false, isStaff: false),
    DefaultUserData(email: "billy.bob@protonmail.com", password: "password", isAdmin: false, isStaff: false),
]
