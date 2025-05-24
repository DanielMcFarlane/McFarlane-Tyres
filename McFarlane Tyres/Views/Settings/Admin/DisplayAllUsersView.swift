//
//  DisplayAllUsersView.swift
//  McFarlane Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This view displays a list of all users for admins.
//

import SwiftData
import SwiftUI

struct DisplayAllUsersView: View {
    @Environment(\.modelContext) private var context
    @Query private var users: [User]
    @State private var userToDelete: User?
    @State private var showDeleteConfirmation = false
    
    var loggedInUser: User? { users.first(where: { $0.loggedIn }) }
    
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
                        // Display total number of users
                        Section(header:
                            Text("Total Users: \(users.count)")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                        ) {
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
                                        Text("Staff")
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
                                    } else {
                                        Text("Customer")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    if user.loggedIn {
                                        Text("(Current user)")
                                            .font(.caption)
                                            .italic()
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .swipeActions(edge: .trailing) {
                                    // Delete only admins or staff
                                    if (user.isAdmin || user.isStaff) && !user.loggedIn {
                                        Button(role: .destructive) {
                                            userToDelete = user
                                            showDeleteConfirmation = true
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .padding(.horizontal, -6)
                }
            }
            .navigationTitle("All Users")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
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

    // MARK: - Helper Functions

    /// Sorts users into three categories: Admins, Staff and Users
    private func sortedUsers() -> [User] {
        let admins = users.filter { $0.isAdmin }
        let staff = users.filter { $0.isStaff && !$0.isAdmin }
        let customers = users.filter { !$0.isAdmin && !$0.isStaff }.sorted { $0.email.lowercased() < $1.email.lowercased() }
        return admins + staff + customers
    }

    /// Deletes the user from the database
    private func deleteUser(_ user: User) {
        if !user.loggedIn {
            context.delete(user)
            
            try? context.save()
        }
    }
}

#Preview {
    DisplayAllUsersView()
        .modelContainer(for: User.self, inMemory: true)
}
