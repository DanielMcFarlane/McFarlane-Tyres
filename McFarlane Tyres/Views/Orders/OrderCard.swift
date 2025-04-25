//
//  OrderCard.swift
//  McFarlane's Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This view displays a card with order details for a specific order.
//

import SwiftUI

struct OrderCard: View {
    var order: Order

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // MARK: - Order Number

            if let orderNumber = order.orderLines.first?.orderNumber {
                // Order number
                Text(orderNumber)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 8)
            }

            // MARK: - Tyre Details

            ForEach(order.orderLines, id: \.id) { orderLineItem in
                HStack(spacing: 16) {
                    // Tyre image
                    Image("Tyre-Stock-Image")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 140)
                        .cornerRadius(12)
                        .shadow(radius: 4)

                    VStack(alignment: .leading, spacing: 8) {
                        // Tyre name
                        Text("\(orderLineItem.tyre.brand) \(orderLineItem.tyre.model)")
                            .font(.title2)
                            .fontWeight(.semibold)

                        // Tyre specifications
                        Text("\(orderLineItem.tyre.width)/\(orderLineItem.tyre.profile)/\(orderLineItem.tyre.rimSize) \(orderLineItem.tyre.speedRating)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        HStack {
                            // Price
                            Text("£\(orderLineItem.tyre.price, specifier: "%.2f")")
                                .font(.title3)
                                .fontWeight(.bold)

                            // Quantity
                            Text("x \(orderLineItem.quantity)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        if orderLineItem.tyre.isWinter {
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
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            Divider().padding(.horizontal, 64)
            
            // MARK: - Total

            HStack {
                // Total
                Text("Total:")
                    .font(.title3)
                    .fontWeight(.bold)

                Spacer()

                // Total price
                Text("£\(order.orderLines.reduce(0) { $0 + $1.tyre.price * Double($1.quantity) }, specifier: "%.2f")")
                    .font(.title3)
                    .fontWeight(.bold)
            }
            .padding()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.12), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    let mockUser = User(
        email: "john.doe@example.com",
        password: "password",
        loggedIn: true,
        isAdmin: false,
        isStaff: false
    )

    let mockTyre = Tyre(
        width: "205",
        profile: "55",
        rimSize: "16",
        brand: "Michelin",
        model: "Primacy 4",
        speedRating: "V",
        price: 89.99,
        isWinter: true,
        category: "All Season",
        orderLines: []
    )

    let mockOrderLine = OrderLine(
        order: Order(
            customer: mockUser,
            orderDate: Date(),
            orderLines: []
        ),
        tyre: mockTyre,
        quantity: 2,
        fittingDate: Date(),
        orderNumber: "ORD123456",
        customerName: "John Doe",
        carRegistration: "AB12 CDE"
    )

    let mockOrder = Order(
        customer: mockUser,
        orderDate: Date(),
        orderLines: [mockOrderLine]
    )

    OrderCard(order: mockOrder)
        .padding()
}
