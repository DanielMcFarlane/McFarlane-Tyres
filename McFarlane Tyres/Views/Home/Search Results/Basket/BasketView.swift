//
//  BasketView.swift
//  McFarlane's Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This view displays the user's tyre basket allowing them to view the selected tyre, adjust the quantity and proceed to checkout.
//

import SwiftData
import SwiftUI

struct BasketView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var context

    @Query private var users: [User]

    @State private var basketItems: [BasketItem] = []

    var isLoggedIn: Bool { users.contains(where: { $0.loggedIn })} // Check if any user is logged in
    var currentUser: User? { users.first(where: { $0.loggedIn }) } // Get the currently logged-in user


    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ZStack {
                    ScrollView {
                        VStack(spacing: 0) {
                            // Title
                            Text("Basket")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.top, 20)

                            if basketItems.isEmpty {
                                // Empty basket message
                                Text("Your basket is empty.")
                                    .font(.title3)
                                    .foregroundColor(.secondary)
                                    .padding()
                            } else {
                                //  Show items in the basket
                                LazyVStack(spacing: 20) {
                                    ForEach(basketItems, id: \.id) { basketItem in
                                        BasketCard(
                                            tyre: basketItem.tyre,
                                            quantity: Binding(
                                                get: { basketItem.quantity },
                                                set: { newQty in
                                                    basketItem.quantity = newQty
                                                    try? context.save()
                                                }
                                            ),

                                            // Remove button
                                            onRemove: {
                                                if let index = basketItems.firstIndex(where: { $0.id == basketItem.id }) {
                                                    basketItems.remove(at: index)
                                                    context.delete(basketItem)
                                                    try? context.save()
                                                }
                                            }
                                        )
                                        .frame(maxWidth: .infinity)
                                        .padding(.horizontal, 20)
                                    }
                                }
                                .padding(.top)
                                .padding(.bottom, 16)

                                // MARK: - Total

                                HStack {
                                    // Total
                                    Text("Total:")
                                        .font(.title3)
                                        .fontWeight(.bold)

                                    Spacer()

                                    // Total price
                                    Text("£\(String(format: "%.2f", basketItems.reduce(0) { $0 + $1.tyre.price * Double($1.quantity) }))")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 16)
                                .padding(.bottom, 16)

                                // MARK: - Checkout Button or Login Message

                                if isLoggedIn {
                                    NavigationLink(destination: CheckoutView(basketItems: basketItems)) {
                                        // Logged in checkout button
                                        Text("Checkout")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color(red: 8 / 255, green: 31 / 255, blue: 92 / 255)) // #081F5C
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.top, 16)
                                    .padding(.bottom, 16)
                                } else {
                                    // Logged out message
                                    Text("Please log in to proceed with checkout")
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
                                        .padding(.horizontal, 20)
                                        .padding(.top, 16)
                                        .padding(.bottom, 16)
                                }
                            }
                        }
                    }
                }
                TaskBarView(currentView: "basket")
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            loadBasket()
        }
    }

    // MARK: - Helper Functions

    /// Loads the basket items for the logged-in user
    private func loadBasket() {
        let manager = BasketManager(context: context)
        basketItems = manager.fetchBasketItems(for: currentUser)
    }

    /// Deletes the selected items from the basket
    private func removeItems(at positions: IndexSet) {
        for index in positions {
            let item = basketItems[index]
            context.delete(item)
        }

        do {
            try context.save()
            loadBasket()
        } catch {
            #if DEBUG
                print("Error deleting item: \(error)")
            #endif
        }
    }
}

#Preview {
    BasketView()
        .modelContainer(for: [
            User.self,
            Tyre.self,
            BasketItem.self,
            Order.self,
            OrderLine.self,
        ], inMemory: true)
}
