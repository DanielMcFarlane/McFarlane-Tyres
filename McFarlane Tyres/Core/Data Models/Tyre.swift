//
//  Tyre.swift
//  McFarlane's Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//

import Foundation
import SwiftData

@Model
class Tyre {
    @Attribute(.unique) var id: UUID
    var width: String
    var profile: String
    var rimSize: String
    var brand: String
    var model: String
    var speedRating: String
    var price: Double
    var isWinter: Bool
    var category: String
    @Relationship var orderLines: [OrderLine]

    init(id: UUID = UUID(), width: String, profile: String, rimSize: String, brand: String, model: String, speedRating: String, price: Double, isWinter: Bool = false, category: String, orderLines: [OrderLine] = []) {
        self.id = id
        self.width = width
        self.profile = profile
        self.rimSize = rimSize
        self.brand = brand
        self.model = model
        self.speedRating = speedRating
        self.price = price
        self.isWinter = isWinter
        self.category = category
        self.orderLines = orderLines
    }
}
