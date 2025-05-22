//
//  OrdersView.swift
//  McFarlane Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This view displays the user's current and previous orders allowing them to review their order history.
//  It fetches orders from the database and displays them in a list which is categorised as upcoming or past orders based on the fitting dates.
//

import SwiftData
import SwiftUI

struct OrdersView: View {
    @Environment(\.modelContext) private var context

    @Query private var users: [User]

    @State private var orders: [Order] = []

    private var today: Date { Calendar.current.startOfDay(for: Date()) }

    // MARK: - Filter and Sort Orders

    /// Filters the orders based on the fitting date and sorts them accordingly
    private func filterOrders(isUpcoming: Bool) -> [Order] {
        orders.filter { order in
            order.orderLines.contains {
                let date = Calendar.current.startOfDay(for: $0.fittingDate)

                return isUpcoming ? date >= today : date < today
            }
        }
        .sorted {
            let lhs = $0.orderLines.first?.fittingDate ?? Date()
            let rhs = $1.orderLines.first?.fittingDate ?? Date()

            return isUpcoming ? lhs < rhs : lhs > rhs
        }
    }

    private var currentOrders: [Order] { filterOrders(isUpcoming: true) }
    private var previousOrders: [Order] { filterOrders(isUpcoming: false) }

    // MARK: - View

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ZStack {
                    Color(UIColor.systemGroupedBackground).ignoresSafeArea()

                    ScrollView {
                        VStack(spacing: 0) {
                            Color.clear.frame(height: 20)
                            // Title
                            Text("My Orders")
                                .font(.largeTitle)
                                .bold()
                                .padding(.top, 20)

                            if orders.isEmpty {
                                // No orders view
                                Text("No orders yet")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .padding()
                            } else {
                                OrderCategoryView(title: "Current Orders", orders: currentOrders, date: "Fitting on")

                                Spacer()

                                OrderCategoryView(title: "Previous Orders", orders: previousOrders, date: "Fitted on")
                            }
                        }
                        .padding(.bottom, 16)
                    }
                }
                TaskBarView(currentView: "orders")
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
            .onAppear {
                // Fetch orders for the logged-in user
                if let user = users.first(where: { $0.loggedIn }) {
                    orders = OrderManager(context: context).fetchOrders(for: user)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("")
            }
        }
    }
}

// MARK: - Order Category View Struct

struct OrderCategoryView: View {
    let title: String
    let orders: [Order]
    let date: String

    var body: some View {
        if !orders.isEmpty {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 16)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(UIColor.systemGroupedBackground))

            LazyVStack(spacing: 16) {
                ForEach(orders, id: \.id) { order in
                    VStack(alignment: .leading, spacing: 8) {
                        // Fitting date formatting
                        Text("\(date) \(order.orderLines.first?.fittingDate.formatted(date: .abbreviated, time: .omitted) ?? "N/A")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        OrderCard(order: order)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                }
            }
        }
    }
}

#Preview {
    OrdersView()
}
