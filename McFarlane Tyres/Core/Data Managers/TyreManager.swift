//
//  TyreManager.swift
//  McFarlane's Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This class handles all operations related to tyre management including creating, reading, searching and loading tyres.
//  It uses SwiftData for persistent storage.
//

import Foundation
import SwiftData

class TyreManager {
    private var context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: Create

    /// Add a new tyre to the database
    func addTyre(width: String, profile: String, rimSize: String, brand: String, model: String, speedRating: String, price: Double, isWinter: Bool = false, category: String) {
        let newTyre = Tyre(
            width: width,
            profile: profile,
            rimSize: rimSize,
            brand: brand,
            model: model,
            speedRating: speedRating,
            price: price,
            isWinter: isWinter,
            category: category
        )
        context.insert(newTyre)
        saveContext()

        #if DEBUG
            print("""

            [TyreManager] 

            Added tyre:-
            \(newTyre.brand) \(newTyre.model)
            \(newTyre.width)/\(newTyre.profile)/R\(newTyre.rimSize) \(newTyre.speedRating)
            £\(newTyre.price)
            \(newTyre.isWinter ? "Winter" : "Summer")

            """)
        #endif
    }

    // MARK: - Read

    /// Fetch all tyres from the database
    func fetchTyres() -> [Tyre] {
        let tyreDescriptor = FetchDescriptor<Tyre>()

        return (try? context.fetch(tyreDescriptor)) ?? []
    }

    /// Fetch all tyre profiles from the database for a given width
    func fetchProfiles(forWidth width: String) -> [String] {
        let tyreProfile = fetchTyres().filter { $0.width == width }

        return Array(Set(tyreProfile.map { $0.profile })).sorted()
    }

    /// Fetch all rim sizes for a given width and profile
    func fetchRimSizes(forWidth width: String, andProfile profile: String) -> [String] {
        let tyreRimSize = fetchTyres().filter { $0.width == width && $0.profile == profile }

        return Array(Set(tyreRimSize.map { $0.rimSize })).sorted()
    }

    /// Fetch all speed ratings for a given width, profile and rim size
    func fetchSpeedRatings(forWidth width: String, profile: String, rimSize: String) -> [String] {
        let tyreSpeedRating = fetchTyres().filter { $0.width == width && $0.profile == profile && $0.rimSize == rimSize }
        let uniqueRatings = Array(Set(tyreSpeedRating.map { $0.speedRating })).sorted()

        return uniqueRatings.count > 1 ? ["Any"] + uniqueRatings : uniqueRatings
    }

    // MARK: - Update

    /// Update an existing tyre in the database
    func updateTyre(tyre: Tyre, width: String, profile: String, rimSize: String, brand: String, model: String, speedRating: String, price: Double, isWinter: Bool, category: String) {
        let originalTyre = "\(tyre.brand) \(tyre.model) \(tyre.width)/\(tyre.profile)/R\(tyre.rimSize) \(tyre.speedRating)"
        let originalPrice = tyre.price
        let originalIsWinter = tyre.isWinter
        let originalCategory = tyre.category

        tyre.width = width
        tyre.profile = profile
        tyre.rimSize = rimSize
        tyre.brand = brand
        tyre.model = model
        tyre.speedRating = speedRating
        tyre.price = price
        tyre.isWinter = isWinter
        tyre.category = category

        saveContext()

        #if DEBUG
            print("""

            [TyreManager] 

            Update successful

            Old tyre: \(originalTyre)
            Price: £\(originalPrice)
            Season: \(originalIsWinter ? "Winter" : "Summer")
            Category: \(originalCategory)

            New tyre: \(tyre.brand) \(tyre.model) \(tyre.width)/\(tyre.profile)/R\(tyre.rimSize) \(tyre.speedRating)
            Price: £\(tyre.price)
            Season: \(tyre.isWinter ? "Winter" : "Summer")
            Category: \(tyre.category)

            """)
        #endif
    }

    // MARK: - Delete

    /// Delete a tyre from the database
    func deleteTyre(_ tyre: Tyre) {
        context.delete(tyre)
        saveContext()

        #if DEBUG
            print("\n[TyreManager] Deleted tyre: \(tyre.brand) \(tyre.model) \(tyre.width)/\(tyre.profile)/R\(tyre.rimSize) \(tyre.speedRating)")
        #endif
    }

    // MARK: - Search

    /// Search for tyres based on width, profile, rim size and speed rating
    func searchTyres(width: String, profile: String, rimSize: String, speed: String) -> [Tyre] {
        let tyres = fetchTyres().filter {
            $0.width == width &&
                $0.profile == profile &&
                $0.rimSize == rimSize &&
                (speed == "Any" || $0.speedRating == speed)
        }
        return tyres
    }

    // MARK: - Data Seeding

    /// Loads the database with default tyre data
    func loadDefaultTyres() {
        if fetchTyres().isEmpty {
            let newTyres = defaultTyreData.flatMap { data in
                data.tyres.map { tyre in
                    Tyre(
                        width: data.width,
                        profile: data.profile,
                        rimSize: data.rimSize,
                        brand: tyre.brand,
                        model: tyre.model,
                        speedRating: tyre.speedRating,
                        price: tyre.price,
                        isWinter: tyre.isWinter,
                        category: tyre.category
                    )
                }
            }

            newTyres.forEach { context.insert($0) }
            saveContext()

            #if DEBUG
                print("\n[TyreManager] \(newTyres.count) tyres loaded successfully.")
            #endif
        }
    }

    // MARK: - Private Helpers

    /// Save changes to the database and simplify code
    private func saveContext() {
        do {
            try context.save()
        } catch {
            #if DEBUG
                print("\n[TyreManager] Error saving the tyre to the database: \(error)")
            #endif
        }
    }
}

// MARK: - Struct to simplify tyre creation

struct TyreDetails {
    let width: String
    let profile: String
    let rimSize: String
    let brand: String
    let model: String
    let speedRating: String
    let price: Double
    let isWinter: Bool
    let category: String
}
