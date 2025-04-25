//
//  DisplayAllOrdersView.swift
//  McFarlane's Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This view displays all order lines for the admin.
//

import SwiftData
import SwiftUI

struct DisplayAllOrdersView: View {
    @Environment(\.modelContext) private var context

    @Query private var orderLines: [OrderLine]

    /// Groups the current order lines by order number
    private var groupedCurrentOrders: [[OrderLine]] {
        groupedOrderLines(orderLines.filter {
            Calendar.current.startOfDay(for: $0.fittingDate) >= Calendar.current.startOfDay(for: Date())
        })
    }

    /// Groups the previous order lines by order number
    private var groupedPreviousOrders: [[OrderLine]] {
        groupedOrderLines(orderLines.filter {
            Calendar.current.startOfDay(for: $0.fittingDate) < Calendar.current.startOfDay(for: Date())
        })
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ZStack {
                    Color(UIColor.systemGroupedBackground).ignoresSafeArea()

                    ScrollView {
                        VStack(spacing: 24) {
                            // No orders view
                            if orderLines.isEmpty {
                                Text("No orders found.")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .padding()
                            } else {
                                // Orders view
                                if !groupedCurrentOrders.isEmpty {
                                    VStack(spacing: 8) {
                                        // Title
                                        Text("Current Orders")
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.horizontal)

                                        VStack(alignment: .leading, spacing: 16) {
                                            // Order lines grouped by order number
                                            LazyVStack(spacing: 16) {
                                                ForEach(groupedCurrentOrders, id: \.first!.id) { group in
                                                    let first = group.first!
                                                    VStack(alignment: .leading, spacing: 8) {
                                                        Text("\(first.orderNumber)")
                                                            .font(.headline)

                                                        ForEach(group, id: \.id) { orderLine in
                                                            // Tyre details
                                                            Text("Tyre: \(orderLine.tyre.brand) \(orderLine.tyre.model) (\(orderLine.tyre.width)/\(orderLine.tyre.profile)/R\(orderLine.tyre.rimSize)/\(orderLine.tyre.speedRating))")
                                                                .font(.subheadline)
                                                                .foregroundColor(.secondary)

                                                            // Quantity
                                                            Text("Quantity: \(orderLine.quantity)")
                                                                .font(.subheadline)
                                                                .foregroundColor(.secondary)
                                                        }

                                                        // Fitting date
                                                        Text("Fitting Date: \(first.fittingDate.formatted(date: .abbreviated, time: .omitted))")
                                                            .font(.subheadline)
                                                            .foregroundColor(.secondary)

                                                        // DiscloosureGroup for more details
                                                        DisclosureGroup("More Details") {
                                                            VStack(alignment: .leading, spacing: 8) {
                                                                // Customer name
                                                                Text("Customer: \(first.customerName)")
                                                                    .font(.subheadline)
                                                                    .foregroundColor(.secondary)

                                                                // Car registration
                                                                Text("Car Registration: \(first.carRegistration)")
                                                                    .font(.subheadline)
                                                                    .foregroundColor(.secondary)
                                                            }
                                                            .frame(maxWidth: .infinity, alignment: .leading)
                                                            .padding(.top, 12)
                                                            .padding(.bottom, 12)
                                                        }
                                                        .font(.subheadline)
                                                        .foregroundColor(.blue)
                                                        .padding(.top, 8)
                                                        .frame(maxWidth: .infinity, alignment: .leading)

                                                        if groupedCurrentOrders.count > 1 && group != groupedCurrentOrders.last {
                                                            Divider()
                                                                .padding(.horizontal, 64)
                                                                .padding(.top, 12)
                                                                .padding(.bottom, 8)
                                                        }
                                                    }
                                                    .padding(.horizontal)
                                                    .cornerRadius(8)
                                                }
                                            }
                                        }
                                        .padding()
                                        .background(Color(UIColor.systemGray6))
                                        .cornerRadius(12)
                                        .shadow(color: .black.opacity(0.12), radius: 5, x: 0, y: 2)
                                        .padding(.horizontal)
                                    }
                                }

                                // Previous orders view
                                if !groupedPreviousOrders.isEmpty {
                                    VStack(spacing: 8) {
                                        // Title
                                        Text("Previous Orders")
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.horizontal)

                                        VStack(alignment: .leading, spacing: 16) {
                                            LazyVStack(spacing: 16) {
                                                // Order lines grouped by order number
                                                ForEach(groupedPreviousOrders, id: \.first!.id) { group in
                                                    let first = group.first!
                                                    VStack(alignment: .leading, spacing: 8) {
                                                        Text("\(first.orderNumber)")
                                                            .font(.headline)

                                                        ForEach(group, id: \.id) { orderLine in
                                                            // Tyre details
                                                            Text("Tyre: \(orderLine.tyre.brand) \(orderLine.tyre.model) (\(orderLine.tyre.width)/\(orderLine.tyre.profile)/R\(orderLine.tyre.rimSize)/\(orderLine.tyre.speedRating))")
                                                                .font(.subheadline)
                                                                .foregroundColor(.secondary)

                                                            // Quantity
                                                            Text("Quantity: \(orderLine.quantity)")
                                                                .font(.subheadline)
                                                                .foregroundColor(.secondary)
                                                        }

                                                        // Fitting date
                                                        Text("Fitted Date: \(first.fittingDate.formatted(date: .abbreviated, time: .omitted))")
                                                            .font(.subheadline)
                                                            .foregroundColor(.secondary)

                                                        // DisclosureGroup for more details
                                                        DisclosureGroup("More Details") {
                                                            VStack(alignment: .leading, spacing: 8) {
                                                                // Customer name
                                                                Text("Customer: \(first.customerName)")
                                                                    .font(.subheadline)
                                                                    .foregroundColor(.secondary)

                                                                // Car registration
                                                                Text("Car Registration: \(first.carRegistration)")
                                                                    .font(.subheadline)
                                                                    .foregroundColor(.secondary)
                                                            }
                                                            .frame(maxWidth: .infinity, alignment: .leading)
                                                            .padding(.top, 12)
                                                            .padding(.bottom, 12)
                                                        }
                                                        .font(.subheadline)
                                                        .foregroundColor(.blue)
                                                        .padding(.top, 8)
                                                        .frame(maxWidth: .infinity, alignment: .leading)

                                                        if groupedPreviousOrders.count > 1 && group != groupedPreviousOrders.last {
                                                            Divider()
                                                                .padding(.horizontal, 64)
                                                                .padding(.top, 12)
                                                                .padding(.bottom, 8)
                                                        }
                                                    }
                                                    .padding(.horizontal)
                                                    .background(Color(UIColor.secondarySystemBackground))
                                                    .cornerRadius(8)
                                                }
                                            }
                                        }
                                        .padding()
                                        .background(Color(UIColor.systemGray6))
                                        .cornerRadius(12)
                                        .shadow(color: .black.opacity(0.12), radius: 5, x: 0, y: 2)
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 16)
                        .padding(.top, 16)
                    }
                }
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("All Orders")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Helper Functions

    /// Groups order lines by their order number and sorts them by fitting date
    private func groupedOrderLines(_ lines: [OrderLine]) -> [[OrderLine]] {
        Dictionary(grouping: lines, by: { $0.orderNumber })
            .values
            .map { $0.sorted { abs($0.fittingDate.timeIntervalSinceNow) < abs($1.fittingDate.timeIntervalSinceNow) } }
            .sorted { abs($0.first!.fittingDate.timeIntervalSinceNow) < abs($1.first!.fittingDate.timeIntervalSinceNow) }
    }
}

#Preview {
    DisplayAllOrdersView()
        .modelContainer(for: OrderLine.self, inMemory: true)
}
