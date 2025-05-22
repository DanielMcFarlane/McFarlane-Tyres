//
//  SearchCard.swift
//  McFarlane's Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This view displays a card with tyre details for the search view.
//

import SwiftData
import SwiftUI

struct SearchCard: View {
    var tyre: Tyre
    var showPopUp: (String) -> Void
    
    @State private var quantity: Int = 1
    
    @Environment(\.modelContext) private var context
    
    @Query private var users: [User]
    
    // Defines the category and colour for each category
    var category: (label: String, color: Color) {
        switch tyre.category.lowercased() {
        case "economy":
            return ("Economy", .green)
        case "midrange":
            return ("Midrange", .orange)
        case "premium":
            return ("Premium", .purple)
        default:
            return ("Unknown", .gray)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 16) {
                    // MARK: - Tyre Details

                    // Tyre image
                    Image("Tyre-Stock-Image")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 140)
                        .cornerRadius(12)
                        .shadow(radius: 4)

                    VStack(alignment: .leading, spacing: 8) {
                        // Category
                        Text(category.label)
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(category.color.opacity(0.25))
                            )
                            .foregroundColor(Color(UIColor.label))

                        // Tyre name
                        Text("\(tyre.brand) \(tyre.model)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .lineLimit(nil)

                        // Tyre specifications
                        Text("\(tyre.width)/\(tyre.profile)/\(tyre.rimSize) \(tyre.speedRating)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        // Price
                        Text("£\(String(format: "%.2f", tyre.price))")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)

                        if tyre.isWinter {
                            // Winter tag
                            Label("Winter Tyre", systemImage: "snowflake")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.15))
                                .foregroundColor(.blue)
                                .cornerRadius(6)
                        }

                        HStack(spacing: 4) {
                            Button(action: {
                                // Minus button
                                if quantity > 1 { quantity -= 1 }
                            }) {
                                Text("-")
                                    .font(.title2)
                                    .frame(width: 32, height: 32)
//                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(.primary)
                                    .cornerRadius(6)
                            }

                            // Quantity
                            Text("\(quantity)")
                                .font(.headline)
                                .frame(width: 32, height: 32)
                                .background(Color(.systemGray6))
                                .foregroundColor(.primary)
                                .cornerRadius(6)

                            Button(action: {
                                // Plus button
                                if quantity < 5 { quantity += 1 }
                            }) {
                                Text("+")
                                    .font(.title2)
                                    .frame(width: 32, height: 32)
//                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(.primary)
                                    .cornerRadius(6)
                            }
                        }
                        .padding(.top, 4)
                        
                        // MARK: - Add to Basket Button
                        Button(action: {
                            let currentUser = users.first(where: { $0.loggedIn })
                            let basketManager = BasketManager(context: context)
                            basketManager.addToBasket(tyre: tyre, quantity: quantity, user: currentUser)
                            
                            showPopUp("x\(quantity)  \(tyre.brand) \(tyre.model) added to basket")
                        }) {
                            Text("Add to Basket")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color(red: 8 / 255, green: 31 / 255, blue: 92 / 255))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top, 8)
                    }
                }
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.12), radius: 5, x: 0, y: 2)
        }
    }
}

#Preview {
    let sampleTyre = Tyre(
        width: "205",
        profile: "55",
        rimSize: "16",
        brand: "Continental",
        model: "ContiPremiumContact 6",
        speedRating: "V",
        price: 89.99,
        isWinter: false,
        category: "Premium"
    )

    SearchCard(tyre: sampleTyre, showPopUp: { _ in })
        .padding()
        .modelContainer(for: Tyre.self, inMemory: true)
}
