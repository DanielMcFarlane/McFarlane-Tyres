//
//  BasketManager.swift
//  McFarlane Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This class handles all operations related to a user's basket including craeating, reading and deleting items.
//  It uses SwiftData for persistent storage.
//

import Foundation
import SwiftData

class BasketManager {
    private var context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Create

    /// Add a tyre to the basket with a given quantity for the specified user
    func addToBasket(tyre: Tyre, quantity: Int, user: User?) {
        let basketItem = BasketItem(
            tyre: tyre,
            quantity: quantity,
            user: user
        )

        context.insert(basketItem)
        saveContext()

        #if DEBUG
            print("""

            [BasketManager] 

            Added to basket:-
            \(tyre.brand) \(tyre.model)
            \(tyre.width)/\(tyre.profile)/R\(tyre.rimSize) \(tyre.speedRating)
            £\(tyre.price)
            \(tyre.isWinter ? "Winter" : "Summer")
            x \(quantity)

            """)
        #endif
    }

    // MARK: - Read

    /// Fetch all basket items for a specific user
    func fetchBasketItems(for user: User?) -> [BasketItem] {
        let basketDescriptor: FetchDescriptor<BasketItem>

        if let user = user {
            let userID = user.id
            basketDescriptor = FetchDescriptor(predicate: #Predicate { item in item.user?.id == userID })
        } else {
            basketDescriptor = FetchDescriptor()
        }

        return (try? context.fetch(basketDescriptor)) ?? []
    }

    // MARK: - Delete

    /// Remove a tyre from the basket
    func removeTyre(_ tyre: BasketItem) {
        context.delete(tyre)
        saveContext()
    }

    /// Clear all basket items for a specific user
    func clearBasket(for user: User?) {
        let items = fetchBasketItems(for: user)

        for item in items {
            context.delete(item)
        }
        saveContext()
    }

    // MARK: - Private Helpers

    /// Save changes to the database and simplify code
    private func saveContext() {
        do {
            try context.save()
        } catch {
            #if DEBUG
                print("\n[BasketManager] Error saving basket to the database: \(error)")
            #endif
        }
    }
}
