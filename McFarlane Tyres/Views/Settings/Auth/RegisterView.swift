//
//  RegisterView.swift
//  McFarlane's Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This view allows the user to register for an account including validation for email format, password strength and confirmation. It also checks if the account already exists and handles error scenarios.
//

import SwiftData
import SwiftUI

struct RegisterView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String?
    @State private var showError = false

    @Query private var users: [User]

    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).ignoresSafeArea()

            ScrollView {
                VStack(spacing: 30) {
                    Spacer().frame(height: 154)
                    // Title
                    Text("Register")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(UIColor.label)) // Adjusts to light/dark mode automatically

                    // Email
                    TextField("Email address", text: $email)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding()
                        .background(colorScheme == .light ? Color(.systemGray5) : Color(.systemGray6)) // Lighter background in light mode
                        .foregroundColor(Color(UIColor.label)) // UIColor.label auto changes for light and dark mode
                        .textInputAutocapitalization(.never)
                        .cornerRadius(8)

                    // Password
                    SecureField("Password", text: $password) // Secure field hides password
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding()
                        .background(colorScheme == .light ? Color(.systemGray5) : Color(.systemGray6))
                        .foregroundColor(Color(UIColor.label))
                        .cornerRadius(8)
                        .textContentType(.newPassword)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)

                    // Confirm password
                    SecureField("Confirm Password", text: $confirmPassword)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding()
                        .background(colorScheme == .light ? Color(.systemGray5) : Color(.systemGray6))
                        .foregroundColor(Color(UIColor.label))
                        .cornerRadius(8)
                        .textContentType(.newPassword)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)

                    // Regiseter button
                    Button {
                        /// Check if email, password and confirm password fields are not empty
                        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
                            errorMessage = "All fields are required."
                            showError = true
                            return
                        }

                        // Validate email format
                        if !isValidEmail(email) {
                            errorMessage = "Invalid email format."
                            showError = true
                            return
                        }

                        // Validate password length
                        if password.count < 6 {
                            errorMessage = "Password must be at least 6 characters long."
                            showError = true
                            return
                        }

                        // Check if passwords match
                        if password != confirmPassword {
                            errorMessage = "Passwords do not match."
                            showError = true
                            return
                        }

                        // Check if user already exists
                        if let _ = users.first(where: { $0.email == email }) {
                            errorMessage = "An account with this email already exists."
                            showError = true
                            return
                        }

                        // Create new user
                        let userManager = UserManager(context: context)
                        userManager.addUser(email: email, password: password)

                        do {
                            try context.save()

                            dismiss() // Go back to login screen
                        } catch {
                            errorMessage = "Failed to save user: \(error.localizedDescription)"
                            showError = true
                            #if DEBUG
                                print("Error saving user: \(error.localizedDescription)")
                            #endif
                        }
                    }

                    label: {
                        // Register button
                        Text("Register")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 8 / 255, green: 31 / 255, blue: 92 / 255)) // #081F5C
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .alert("Registration Error", isPresented: $showError) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text(errorMessage ?? "Something went wrong.")
                    }

                    Spacer()
                }
                .padding(.horizontal)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }

        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            email = ""
            password = ""
            confirmPassword = ""
        }
        .onTapGesture {
            hideKeyboard()
        }
    }

    // MARK: Helper Functions

    /// Validate email format
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    NavigationStack {
        RegisterView()
            .modelContainer(for: User.self, inMemory: true)
    }
}
