//
//  DisplayAllUsersView.swift
//  McFarlane's Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This view displays a list of all users for admins.
//

import SwiftData
import SwiftUI

struct DisplayAllUsersView: View {
    @Environment(\.modelContext) private var context
    @State private var users: [User] = []
    @State private var userToDelete: User?
    @State private var showDeleteConfirmation = false

    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).ignoresSafeArea()
            
            VStack {
                // Empty view
                if users.isEmpty {
                    Text("No users found.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    List {
                        // Display all users
                        ForEach(sortedUsers(), id: \.id) { user in
                            VStack(alignment: .leading) {
                                Text(user.email)
                                    .font(.headline)
                                // Display user role
                                if user.isAdmin {
                                    Text("Admin")
                                        .font(.subheadline)
                                        .foregroundColor(.red)
                                } else if user.isStaff {
                                    // Display staff role
                                    Text("Staff")
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                } else {
                                    // Display customer role
                                    Text("Customer")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .onDelete(perform: confirmDelete)
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("All Users")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
            .onAppear {
                fetchAllUsers()
            }
            .alert("Delete User", isPresented: $showDeleteConfirmation, presenting: userToDelete) { user in
                Button("Delete", role: .destructive) {
                    deleteUser(user)
                }
                Button("Cancel", role: .cancel) { }
            } message: { user in
                Text("Are you sure you want to delete \(user.email)?")
            }
        }
    }

    // MARK: - Hewpful Functions

    /// Fetches all users from the database
    private func fetchAllUsers() {
        let userManager = UserManager(context: context)
        users = userManager.fetchUsers()
    }

    /// Sorts users into three categories: Admins, Staff and Users
    private func sortedUsers() -> [User] {
        let admins = users.filter { $0.isAdmin }
        let staff = users.filter { $0.isStaff && !$0.isAdmin }
        let user = users.filter { !$0.isAdmin && !$0.isStaff }.sorted { $0.email.lowercased() < $1.email.lowercased() }
        return admins + staff + user
    }

    /// Shows a confirmation alert
    private func confirmDelete(at offsets: IndexSet) {
        if let index = offsets.first {
            userToDelete = sortedUsers()[index]
            showDeleteConfirmation = true
        }
    }

    /// Deletes the user from the database
    private func deleteUser(_ user: User) {
        let userManager = UserManager(context: context)
        userManager.deleteUser(user)
        fetchAllUsers()
    }
}

#Preview {
    DisplayAllUsersView()
        .modelContainer(for: User.self, inMemory: true)
}
