//
//  ChangePasswordView.swift
//  McFarlane's Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This view allows the user to change their password including validation and error handling.
//

import CryptoKit
import SwiftData
import SwiftUI

struct ChangePasswordView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context

    @State private var email: String = ""
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var showSuccessAlert = false

    let loggedInUser: User
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                // Title
                Text("Change Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(UIColor.label))
                    .padding(.top, 40)

                formField(
                    placeholder: "Email address",
                    text: $email,
                    isSecure: false
                )

                // MARK: - Current password

                formField(
                    placeholder: "Current Password",
                    text: $currentPassword,
                    isSecure: true
                )

                // MARK: - New password

                formField(
                    placeholder: "New Password",
                    text: $newPassword,
                    isSecure: true
                )

                // MARK: - Confirm password

                formField(
                    placeholder: "Confirm Password",
                    text: $confirmPassword,
                    isSecure: true
                )

                // MARK: - Update password button

                Button(action: updatePassword) {
                    Text("Update Password")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 8 / 255, green: 31 / 255, blue: 92 / 255)) // #081F5C
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)

                Spacer()
            }
            .padding(.horizontal)
            .ignoresSafeArea(.keyboard)
        }
        .onTapGesture {
            hideKeyboard()
        }
        .alert("Success", isPresented: $showSuccessAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your password was updated successfully.")
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage ?? "An unknown error occurred.")
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
    }

    // MARK: - Helper Functions

    /// Creates a form field with a placeholder and text binding
    private func formField(placeholder: String, text: Binding<String>, isSecure: Bool) -> some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: text)
                    .textFieldStyle(PlainTextFieldStyle())
            } else {
                TextField(placeholder, text: text)
                    .textFieldStyle(PlainTextFieldStyle())
            }
        }
        .padding()
        .background(colorScheme == .light ? Color(.systemGray5) : Color(.systemGray6))
        .foregroundColor(Color(UIColor.label))
        .cornerRadius(8)
        .textContentType(.oneTimeCode) // Fixes the yellow autofill box issue
        .autocorrectionDisabled(true)
        .textInputAutocapitalization(.never)
    }

    /// This function is called when the user taps the update password button
    private func updatePassword() {
        // Verify that all fields are filled with early exit
        guard !email.isEmpty, !currentPassword.isEmpty, !newPassword.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "All fields are required."
            showError = true
            return
        }

        let fetchRequest = FetchDescriptor<User>(predicate: #Predicate { $0.email == email })

        do {
            let results = try context.fetch(fetchRequest)

            // Verify that email exists
            if results.isEmpty {
                errorMessage = "No user found with that email address."
                showError = true
                return
            }

            if let user = results.first {
                // Verify that the current password is correct
                let components = user.password.split(separator: "$")
                guard components.count == 2,
                      let salt = components.first,
                      let storedHash = components.last else {
                    errorMessage = "Invalid stored password format."
                    showError = true
                    return
                }

                // Recreate the hash using the current password and salt
                let input = "\(salt)\(currentPassword)"
                let recreatedHash = SHA256.hash(data: Data(input.utf8))
                    .compactMap { String(format: "%02x", $0) }
                    .joined()

                // Verify the current password
                if recreatedHash != storedHash {
                    errorMessage = "Incorrect current password."
                    showError = true
                    return
                }

                // Verify new password is different from current password
                if newPassword == currentPassword {
                    errorMessage = "The new password cannot be the same as your current password."
                    showError = true
                    return
                }

                // Verify that the new password and confirm password match
                if newPassword != confirmPassword {
                    errorMessage = "The new password and confirmation password do not match."
                    showError = true
                    return
                }

                // Verify new password length
                if newPassword.count < 6 {
                    errorMessage = "The new password must be at least 6 characters long."
                    showError = true

                    return
                }

                // Hash the new password
                let userManager = UserManager(context: context)
                userManager.updatePassword(for: user, newPassword: newPassword)

                try context.save()

                showSuccessAlert = true
            }

        } catch {
            errorMessage = "Failed to update password."
            showError = true
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    let previewUser = User(email: "", password: "")
    return ChangePasswordView(loggedInUser: previewUser)
        .modelContainer(for: User.self, inMemory: false)
}
