//
//  OrderConfirmationView.swift
//  McFarlane Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This view displays a summary of the user's order.
//  It shows a confirmation message, order details and additional customer information.
//

import SwiftUI

struct OrderConfirmationView: View {
    var basketItems: [BasketItem]
    var bookingDate: Date
    var orderNumber: String
    var customerName: String
    var carRegistration: String

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ZStack {
                    ScrollView {
                        VStack(spacing: 24) {
                            // MARK: - Order Details Card

                            // Title
                            Text("Order Confirmation")
                                .font(.largeTitle)
                                .bold()
                                .padding(.top, 20)

                            Group {
                                // Order number
                                Text("\(orderNumber)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)

                                // Thank you message
                                Text("Thank you for your order!")
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)

                                // Order details card
                                OrderDetailsCard(
                                    basketItems: basketItems,
                                    bookingDate: bookingDate
                                )
                            }

                            Divider()
                                .background(Color.gray.opacity(0.5))
                                .padding(.horizontal, 64)
                                .padding(.vertical, 8)

                            // MARK: - Additional Information Card

                            VStack(alignment: .leading, spacing: 12) {
                                // Title
                                Text("Additional Information")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .padding(.bottom, 8)

                                Group {
                                    // Customer name
                                    Text("Name: \(customerName)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)

                                    // Car registration
                                    Text("Registration Number: \(carRegistration)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)

                                    // Fitting date
                                    Text("Fitting Date: \(bookingDate.formatted(date: .long, time: .omitted))")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.leading, 4)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.12), radius: 5, x: 0, y: 2)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 16)
                    }
                    .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
                }
                TaskBarView(currentView: "orderConfirmation")
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    let sampleTyre1 = Tyre(
        width: "205",
        profile: "55",
        rimSize: "16",
        brand: "Michelin",
        model: "Primacy 4",
        speedRating: "V",
        price: 89.99,
        isWinter: false,
        category: "Premium"
    )

    let sampleTyre2 = Tyre(
        width: "195",
        profile: "65",
        rimSize: "15",
        brand: "Pirelli",
        model: "Cinturato P7",
        speedRating: "H",
        price: 102.50,
        isWinter: true,
        category: "Standard"
    )

    return OrderConfirmationView(
        basketItems: [
            BasketItem(tyre: sampleTyre1, quantity: 2),
            BasketItem(tyre: sampleTyre2, quantity: 1),
        ],
        bookingDate: Date(),
        orderNumber: "Order # 12345678",
        customerName: "John Joe",
        carRegistration: "AB12 CDE"
    )
}
