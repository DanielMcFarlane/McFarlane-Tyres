//
//  BasketCard.swift
//  McFarlane Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This view displays a card with tyre details for the basket view.
//

import SwiftData
import SwiftUI

struct BasketCard: View {
    var tyre: Tyre
    @Binding var quantity: Int
    var onRemove: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            // MARK: - Tyre Details

            // Tyre image
            Image("Tyre-Stock-Image")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 140)
                .cornerRadius(12)
                .shadow(radius: 4)

            VStack(alignment: .leading, spacing: 8) {
                // Tyre name
                Text("\(tyre.brand) \(tyre.model)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .lineLimit(nil)

                // Tyre specifications
                Text("\(tyre.width)/\(tyre.profile)/\(tyre.rimSize) \(tyre.speedRating)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

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

                HStack {
                    Text("£\(String(format: "%.2f", tyre.price * Double(quantity)))")
                        .font(.title3)
                        .fontWeight(.bold)

                    Spacer()

                    HStack(spacing: 4) {
                        // Minus button or trash icon
                        Button(action: {
                            if quantity > 1 {
                                quantity -= 1
                            } else {
                                onRemove()
                            }
                        }) {
                            Image(systemName: quantity == 1 ? "trash" : "")
                                .font(quantity == 1 ? .headline : .title2)
                                .foregroundColor(.primary)
                            if quantity > 1 {
                                Text("-")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                            }
                        }
                        .frame(width: 32, height: 32)
//                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(6)
                        
                        // Quantity
                        Text("\(quantity)")
                            .font(.headline)
                            .frame(width: 32, height: 32)
                            .background(Color(.systemGray6))
                            .cornerRadius(6)

                        Button(action: {
                            // Plus button
                            if quantity < 5 { quantity += 1 }
                        }) {
                            Text("+")
                                .font(.title2)
                                .foregroundColor(.primary)
                                .frame(width: 32, height: 32)
//                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(6)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.12), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    @Previewable @State var quantity1: Int = 2
    @Previewable @State var quantity2: Int = 1

    let sampleTyre1 = Tyre(
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

    let sampleTyre2 = Tyre(
        width: "195",
        profile: "65",
        rimSize: "15",
        brand: "Michelin",
        model: "Energy Saver",
        speedRating: "H",
        price: 74.99,
        isWinter: true,
        category: "Economy"
    )

    return VStack {
        BasketCard(tyre: sampleTyre1, quantity: $quantity1, onRemove: {
            print("Item removed for Tyre 1")
        })
        BasketCard(tyre: sampleTyre2, quantity: $quantity2, onRemove: {
            print("Item removed for Tyre 2")
        })
    }
    .padding()
    .modelContainer(for: Tyre.self, inMemory: true)
}
