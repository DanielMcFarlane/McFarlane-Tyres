//
//  BasketItem.swift
//  McFarlane Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//

import Foundation
import SwiftData

@Model
class BasketItem {
    @Attribute(.unique) var id: UUID
    var tyre: Tyre
    var quantity: Int
    var user: User?

    init(id: UUID = UUID(), tyre: Tyre, quantity: Int, user: User? = nil) {
        self.id = id
        self.tyre = tyre
        self.quantity = quantity
        self.user = user
    }
}
