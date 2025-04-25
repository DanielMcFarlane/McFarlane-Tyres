//
//  OrderManager.swift
//  McFarlane's Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This class handles all operations related to order management including creating and reading orders.
//  It uses SwiftData for persistent storage.
//

import Foundation
import SwiftData

class OrderManager {
    private var context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Create

    /// Create a new order for a customer with selected tyres and fitting details
    func createOrder(
        for customer: User,
        with tyres: [(tyre: Tyre, quantity: Int, fittingDate: Date)],
        orderNumber: String,
        customerName: String,
        carRegistration: String
    ) {
        let order = Order(
            customer: customer,
            orderDate: Date()
        )

        for item in tyres {
            let orderLine = OrderLine(
                order: order,
                tyre: item.tyre,
                quantity: item.quantity,
                fittingDate: item.fittingDate,
                orderNumber: orderNumber,
                customerName: customerName,
                carRegistration: carRegistration
            )
            order.orderLines.append(orderLine)
        }
        context.insert(order)

        #if DEBUG
            print("""

            [OrderManager]

            \(orderNumber) successfully created

            Customer Name: \(customerName)
            Car Registration: \(carRegistration)
            Fitting Date: \(order.orderLines.first?.fittingDate ?? Date())

            """)

            order.orderLines.forEach { orderLine in
                print("x \(orderLine.quantity) \(orderLine.tyre.brand) \(orderLine.tyre.model) (\(orderLine.tyre.width)/\(orderLine.tyre.profile)/R\(orderLine.tyre.rimSize)/\(orderLine.tyre.speedRating))")
            }
        #endif
    }

    // MARK: - Read

    /// Fetch all orders for a specified user
    func fetchOrders(for user: User) -> [Order] {
        let userId = user.id
        let orderDescriptor = FetchDescriptor<Order>(predicate: #Predicate<Order> { $0.customer.id == userId })

        return (try? context.fetch(orderDescriptor)) ?? []
    }
}
