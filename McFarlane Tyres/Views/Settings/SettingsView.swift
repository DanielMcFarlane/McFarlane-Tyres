//
//  SettingsView.swift
//  McFarlane Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This displays the settings available depending on the user's logged-in state.
//

import SwiftData
import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) private var context
    @Query private var users: [User]
    @Query private var tyres: [Tyre]

    @State private var showLogoutConfirmation = false
    @State private var showDeleteConfirmation = false
    @State private var showGenerateConfirmation = false

    var loggedInUser: User? { users.first(where: { $0.loggedIn }) } // Current user
    var isLoggedIn: Bool { loggedInUser != nil } // Check if user is logged in
    var isAdmin: Bool { loggedInUser?.isAdmin == true } // Check if user is an admin
    var isStaff: Bool { loggedInUser?.isStaff == true } // Check if user is staff

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List {
                    if isLoggedIn {
                        accountSettingsSection
                    }

                    if isStaff {
                        staffControlsSection
                    }

                    #if DEBUG
                        if isAdmin {
                            adminActionsSection
                        }
                    #endif

                    legalSection
                    authSection
                }
                .frame(maxHeight: .infinity)
                .listStyle(InsetGroupedListStyle())
                .environment(\.defaultMinListRowHeight, 50)
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)

                TaskBarView(currentView: "account")
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        }
    }

    // MARK: - Sections

    // Account settings section
    private var accountSettingsSection: some View {
        Section(header: Text("Account Settings").font(.headline)) {
            if let user = loggedInUser {
                NavigationLink {
                    OrdersView()
                } label: {
                    Text("Order History")
                        .font(.body)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                NavigationLink {
                    ChangePasswordView(loggedInUser: user)
                } label: {
                    Text("Change Password")
                        .font(.body)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    // Staff controls section
    private var staffControlsSection: some View {
        Section(header: Text(isAdmin ? "Admin Controls" : "Staff Controls").font(.headline)) {
            if isAdmin {
                NavigationLink {
                    DisplayAllOrdersView()
                } label: {
                    Text("View All Orders")
                        .font(.body)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                NavigationLink {
                    ManageTyresView()
                } label: {
                    Text("Manage Products")
                        .font(.body)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                NavigationLink {
                    DisplayAllUsersView()
                } label: {
                    Text("View All Users")
                        .font(.body)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                NavigationLink {
                    AddUserView()
                } label: {
                    Text("Add User")
                        .font(.body)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else {
                NavigationLink {
                    DisplayAllOrdersView()
                } label: {
                    Text("View All Orders")
                        .font(.body)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    // Admin actions section
    private var adminActionsSection: some View {
        Section(header: Text("Admin Actions (Debug Only)").font(.headline)) {
            // Generate sample orders button
            Button {
                showGenerateConfirmation = true
            } label: {
                Text("Generate Sample Orders")
                    .font(.body)
                    .foregroundColor(.accentColor)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .alert("Are you sure you want to generate sample orders?", isPresented: $showGenerateConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Generate", role: .destructive) {
                    generateSampleOrders()
                }
            }

            // Clear all orders button
            Button {
                showDeleteConfirmation = true
            } label: {
                Text("Clear All Orders")
                    .font(.body)
                    .foregroundColor(.red)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .alert("Are you sure you want to delete all orders?", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete All", role: .destructive) {
                    deleteAllOrders()
                }
            }
        }
    }

    // Legal and support section
    private var legalSection: some View {
        Section(header: Text("Legal & Support").font(.headline)) {
            NavigationLink {
                TaCView()
            } label: {
                Text("Terms and Conditions")
                    .font(.body)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    // Login/logout section
    private var authSection: some View {
        Section(header: Text(" ").opacity(0)) {
            if isLoggedIn {
                // Logout button
                Button {
                    showLogoutConfirmation = true
                } label: {
                    Text("Logout")
                        .font(.body)
                        .foregroundColor(.red)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .alert("Are you sure you want to log out?", isPresented: $showLogoutConfirmation) {
                    Button("Cancel", role: .cancel) { }
                    Button("Log Out", role: .destructive) {
                        logout()
                    }
                }
            } else {
                NavigationLink {
                    LoginView()
                } label: {
                    Text("Login")
                        .font(.body)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    /// Logs out the current user
    private func logout() {
        for user in users where user.loggedIn {
            user.loggedIn = false

            let basketManager = BasketManager(context: context)
            basketManager.clearBasket(for: user)
            print("User logged out: \(user.email)")
        }
        try? context.save()
    }

    // MARK: - Debug Functions

    #if DEBUG
        /// Generates sample orders for testing purposes
        func generateSampleOrders() {
            let orderManager = OrderManager(context: context)
            let availableTyres = tyres.shuffled()
            let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            let now = Date()
            let customerUsers = defaultUsers.filter { !$0.isAdmin && !$0.isStaff }

            var orderCounter = 1
            var ordersGenerated = 0

            for defaultUser in customerUsers {
                guard let user = users.first(where: { $0.email == defaultUser.email }) else {
                    print("No existing user found for email: \(defaultUser.email)")
                    continue
                }

                let orderCount = Int.random(in: 1 ... 8)

                for _ in 1 ... orderCount {
                    let tyreVarietyCount = Int.random(in: 1 ... 2)
                    var tyresForOrder: [(tyre: Tyre, quantity: Int, fittingDate: Date)] = []

                    let daysOffset = Int.random(in: -60 ... 14)
                    let fittingDate = Calendar.current.date(byAdding: .day, value: daysOffset, to: now)!

                    for _ in 1 ... tyreVarietyCount {
                        if let tyre = availableTyres.randomElement() {
                            let quantity = Int.random(in: 1 ... 4)
                            tyresForOrder.append((tyre: tyre, quantity: quantity, fittingDate: fittingDate))
                        }
                    }

                    if !tyresForOrder.isEmpty {
                        let orderNumber = "Order # \(String(format: "%06d", orderCounter))"
                        let firstLetters = String((0 ..< 2).map { _ in letters.randomElement()! })
                        let numbers = String(format: "%02d", Int.random(in: 10 ... 99))
                        let lastLetters = String((0 ..< 3).map { _ in letters.randomElement()! })
                        let reg = "\(firstLetters)\(numbers) \(lastLetters)"

                        orderManager.createOrder(
                            for: user,
                            with: tyresForOrder,
                            orderNumber: orderNumber,
                            customerName: user.email,
                            carRegistration: reg
                        )

                        orderCounter += 1
                        ordersGenerated += 1
                    }
                }
            }

            print("\n\(ordersGenerated) orders generated successfully")
        }

        /// Deletes all orders and order lines
        func deleteAllOrders() {
            let orderFetch = FetchDescriptor<Order>()
            let orderLineFetch = FetchDescriptor<OrderLine>()

            do {
                let allOrders = try context.fetch(orderFetch)
                let allOrderLines = try context.fetch(orderLineFetch)

                for line in allOrderLines {
                    context.delete(line)
                }

                for order in allOrders {
                    context.delete(order)
                }

                try context.save()
                print("All orders and order lines deleted.")
            } catch {
                print("Error deleting orders: \(error)")
            }
        }
    #endif
}

#Preview {
    SettingsView()
        .modelContainer(for: [User.self, Tyre.self], inMemory: true)
}
