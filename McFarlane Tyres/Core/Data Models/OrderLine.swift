//
//  OrderLine.swift
//  McFarlane's Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//

import Foundation
import SwiftData

@Model
class OrderLine {
    @Attribute(.unique) var id: UUID
    var order: Order
    var tyre: Tyre
    var quantity: Int
    var fittingDate: Date
    var orderNumber: String
    var customerName: String
    var carRegistration: String

    init(
        id: UUID = UUID(),
        order: Order,
        tyre: Tyre,
        quantity: Int,
        fittingDate: Date,
        orderNumber: String,
        customerName: String,
        carRegistration: String
    ) {
        self.id = id
        self.order = order
        self.tyre = tyre
        self.quantity = quantity
        self.fittingDate = fittingDate
        self.orderNumber = orderNumber
        self.customerName = customerName
        self.carRegistration = carRegistration
    }
}
