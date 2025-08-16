//
//  LoginView.swift
//  McFarlane Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This view handles user login functionality including validation of credentials, error handling and navigation to the home screen if the login is successful.
//

import CryptoKit
import SwiftData
import SwiftUI

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError = false
    @State private var errorMessage: String?

    @Query private var users: [User]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                VStack(spacing: 30) {
                    Spacer()

                    // Title
                    Text("Login")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(UIColor.label))

                    // Email text field
                    TextField("Email address", text: $email)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding()
                        .background(colorScheme == .light ? Color(.systemGray5) : Color(.systemGray6))
                        .foregroundColor(Color(UIColor.label))
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .cornerRadius(8)

                    // Password text field
                    SecureField("Password", text: $password)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding()
                        .background(colorScheme == .light ? Color(.systemGray5) : Color(.systemGray6))
                        .foregroundColor(Color(UIColor.label))
                        .cornerRadius(8)

                    // Login button
                    Button {
                        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
                        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

                        #if DEBUG
                            print("""

                            Logging in with user:-
                            Email: \(trimmedEmail)
                            Password: \(trimmedPassword)

                            """)
                        #endif

                        // Validate input with early exit
                        guard !trimmedEmail.isEmpty, !trimmedPassword.isEmpty else {
                            errorMessage = "Email and password are required"
                            showError = true
                            return
                        }

                        // Validate login with early exit
                        guard let loginError = loginUser(email: trimmedEmail, password: trimmedPassword) else {
                            dismiss()
                            return
                        }

                        errorMessage = loginError
                        showError = true

                    } label: {
                        // Login button
                        Text("Log in")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 8 / 255, green: 31 / 255, blue: 92 / 255)) // #081F5C
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .alert("Login Error", isPresented: $showError) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text(errorMessage ?? "Something went wrong")
                    }

                    Spacer()

                    // Create new account button
                    NavigationLink(destination: RegisterView()) {
                        Text("Create new account")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(
                                colorScheme == .light ?
                                    Color(red: 8 / 255, green: 31 / 255, blue: 92 / 255) :
                                    Color(UIColor.label)
                            )
                            .background(Color.clear)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        colorScheme == .light ?
                                            Color(red: 8 / 255, green: 31 / 255, blue: 92 / 255) :
                                            Color(UIColor.secondaryLabel)
                                    )
                            )
                    }
                    Spacer().frame(height: 24)
                }
                .padding(.horizontal, 14)
                .ignoresSafeArea(.keyboard)
            }
        }
        .onAppear {
            email = ""
            password = ""
        }
        .onTapGesture {
            hideKeyboard()
        }
    }

    // MARK: - Helper Functions

    /// This function handles the login process by checking the user's credentials
    private func loginUser(email: String, password: String) -> String? {
        // Early exit if the email doesn't exist in database
        guard let user = users.first(where: { $0.email == email }) else {
            return "No account found with this email"
        }

        let components = user.password.split(separator: "$") // Split the stored password into salt and hash

        // Early exit if the password format is incorrect
        guard components.count == 2,
              let salt = components.first,
              let storedHash = components.last else {
            return "Incorrect password"
        }

        // Recreate the hash using the entered password and the stored salt
        let input = "\(salt)\(password)"
        let recreatedHash = SHA256.hash(data: Data(input.utf8))
            .compactMap { String(format: "%02x", $0) }
            .joined()

        // Compare the recreated hash with the stored hash
        if recreatedHash == storedHash {
            user.loggedIn = true

            if user.email == "admin" {
                user.isAdmin = true
            }
            
            try? context.save()
            return nil
        }
        return "Incorrect password"
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    LoginView()
        .modelContainer(for: User.self, inMemory: false)
}
