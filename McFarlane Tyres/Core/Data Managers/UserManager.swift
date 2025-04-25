//
//  UserManager.swift
//  McFarlane's Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This class handles all operations related to user management including creating, reading, updating, deleting, validating and salting passwords.
//  It uses SwiftData for persistent storage.
//

import CryptoKit
import Foundation
import SwiftData

class UserManager {
    private var context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Create

    /// Add a user to the database
    func addUser(email: String, password: String, isAdmin: Bool = false, isStaff: Bool = false) {
        let hashedPassword = saltedHash(password)
        let newUser = User(
            email: email,
            password: hashedPassword,
            isAdmin: isAdmin,
            isStaff: isStaff
        )

        context.insert(newUser)
        saveContext()

        #if DEBUG
            print("""

            [UserManager] 

            User added: \(newUser.email)
            Plain password: \(password)
            Salty hashed password: \(newUser.password)
            Role: \(newUser.isAdmin ? "Admin" : newUser.isStaff ? "Staff" : "Customer")

            """)
        #endif
    }

    // MARK: - Read

    /// Fetch all users from the database
    func fetchUsers() -> [User] {
        let userDescriptor = FetchDescriptor<User>()

        return (try? context.fetch(userDescriptor)) ?? []
    }

    // MARK: - Update

    /// Update the users password and save it to the database
    func updatePassword(for user: User, newPassword: String) {
        let hashedPassword = saltedHash(newPassword)
        user.password = hashedPassword

        #if DEBUG
            print("""

            [UserManager] 

            Updated password for \(user.email)
            New password: \(newPassword)
            New hashed password: \(user.password)

            """)
        #endif
    }

    // MARK: - Delete

    /// Deletes a user from the database
    func deleteUser(_ user: User) {
        context.delete(user)
        saveContext()

        #if DEBUG
            print("""

            [UserManager]

            Deleted user:-
            Email: \(user.email)
            Password: \(user.password)
            Role: \(user.isAdmin ? "Admin" : user.isStaff ? "Staff" : "Customer")

            """)
        #endif
    }

    // MARK: - Validate

    // Check if a user already exists in the database
    func isRegisteredEmail(email: String) -> Bool {
        let emailRegisteredDescriptor = FetchDescriptor<User>(predicate: #Predicate { $0.email == email })

        return (try? context.fetch(emailRegisteredDescriptor))?.first != nil
    }

    // MARK: - Data Seeding

    /// Loads the database with default user data
    func loadDefaultUsers() {
        if fetchUsers().isEmpty {
            let newUsers = defaultUsers.map { userData in
                User(
                    email: userData.email,
                    password: saltedHash(userData.password),
                    isAdmin: userData.isAdmin,
                    isStaff: userData.isStaff
                )
            }

            newUsers.forEach { context.insert($0) }
            saveContext()

            #if DEBUG
                print("\n[UserManager] \(newUsers.count) users loaded successfully.")
            #endif
        }
    }

    // MARK: - Private Helpers

    /// Generate a random salt for hashing
    private func randomSalt(length: Int = 32) -> String {
        let randomSalt = Data((0 ..< length).map { _ in UInt8.random(in: 0 ... 255) })

        return randomSalt.map { String(format: "%02x", $0) }.joined() // Convert to hex string
    }

    /// Hash the password with a salt
    private func saltedHash(_ password: String) -> String {
        let salt = randomSalt() // Generate a random salt
        let input = salt + password // Make a salty password
        let saltyPassword = SHA256.hash(data: Data(input.utf8)) // Google take the wheel
        let hashHex = saltyPassword.compactMap { String(format: "%02x", $0) }.joined() // Convert to hex string

        return "\(salt)$\(hashHex)"
    }

    /// Save changes to the database and simplify code
    private func saveContext() {
        do {
            try context.save()
        } catch {
            #if DEBUG
                print("\n[UserManager] Error saving user to the database : \(error)")
            #endif
        }
    }
}
