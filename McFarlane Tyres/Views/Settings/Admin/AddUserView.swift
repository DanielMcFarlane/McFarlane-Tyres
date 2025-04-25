//
//  AddUserView.swift
//  McFarlane's Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This view allows an admin user to add a new user to the system.
//

import SwiftData
import SwiftUI

struct AddUserView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isAdmin: Bool = false
    @State private var isStaff: Bool = false
    @State private var errorMessage: String?
    @State private var showError: Bool = false

    @Query private var users: [User]

    var body: some View {
        ZStack {
             ScrollView {
                VStack(spacing: 30) {
                    Spacer().frame(height: 154)

                    // Title
                    Text("Add User")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(UIColor.label))

                    // Email text field
                    TextField("Email address", text: $email)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding()
                        .frame(height: 50)
                        .background(colorScheme == .light ? Color(.systemGray5) : Color(.systemGray6))
                        .foregroundColor(Color(UIColor.label))
                        .textInputAutocapitalization(.never)
                        .cornerRadius(8)

                    // Password text field
                    SecureField("Password", text: $password)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding()
                        .frame(height: 50)
                        .background(colorScheme == .light ? Color(.systemGray5) : Color(.systemGray6))
                        .foregroundColor(Color(UIColor.label))
                        .cornerRadius(8)
                        .textContentType(.newPassword)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)

                    // Confirm password text field
                    SecureField("Confirm Password", text: $confirmPassword)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding()
                        .frame(height: 50)
                        .background(colorScheme == .light ? Color(.systemGray5) : Color(.systemGray6))
                        .foregroundColor(Color(UIColor.label))
                        .cornerRadius(8)
                        .textContentType(.newPassword)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)

                    VStack(spacing: 6) {
                        // Admin toggle
                        Toggle("Set as Admin", isOn: Binding(
                            get: { isAdmin },
                            set: { newValue in
                                isAdmin = newValue
                                if newValue { isStaff = false }
                            }
                        ))
                        .padding()

                        // Staff toggle
                        Toggle("Set as Staff", isOn: Binding(
                            get: { isStaff },
                            set: { newValue in
                                isStaff = newValue
                                if newValue { isAdmin = false }
                            }
                        ))
                        .padding()
                    }

                    // Add User button
                    Button {
                        /// Early exit if any field is empty
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

                        // Use UserManager to create user
                        let userManager = UserManager(context: context)
                        userManager.addUser(email: email, password: password, isAdmin: isAdmin, isStaff: isAdmin || isStaff)

                        do {
                            try context.save()

                            dismiss()
                        } catch {
                            errorMessage = "Failed to save user: \(error.localizedDescription)"
                            showError = true
                            #if DEBUG
                                print("Error saving user: \(error.localizedDescription)")
                            #endif
                        }
                    } label: {
                        // Add User button
                        Text("Add User")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 8 / 255, green: 31 / 255, blue: 92 / 255)) // #081F5C
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .alert("Error", isPresented: $showError) {
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
        .onTapGesture {
            hideKeyboard()
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
    }

    // MARK: - Helper Functions

    /// This function checks if the email is valid
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    AddUserView()
        .modelContainer(for: User.self, inMemory: true)
}
