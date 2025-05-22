//
//  Order.swift
//  McFarlane Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//

import Foundation
import SwiftData

@Model
class Order {
    @Attribute(.unique) var id: UUID
    var customer: User
    var orderDate: Date
    @Relationship var orderLines: [OrderLine]

    init(
        id: UUID = UUID(),
        customer: User,
        orderDate: Date,
        orderLines: [OrderLine] = [],
    ) {
        self.id = id
        self.customer = customer
        self.orderDate = orderDate
        self.orderLines = orderLines
    }
}
