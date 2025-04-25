//
//  ManageProductsView.swift
//  McFarlane's Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This view allows admins to manage products.
//

import SwiftData
import SwiftUI

struct ManageProductsView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) var colorScheme

    @Query(sort: [SortDescriptor(\Tyre.rimSize), SortDescriptor(\Tyre.profile), SortDescriptor(\Tyre.width)]) private var tyres: [Tyre]

    @State private var searchRimSize: String = ""
    @State private var showingAddTyreSheet = false
    @State private var selectedCategory = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ZStack {
                    ScrollView {
                        VStack(spacing: 20) {
                            HStack {
                                // Search bar
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                TextField("Search by rim size...", text: $searchRimSize)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .keyboardType(.numberPad)
                            }
                            .padding()
                            .background(colorScheme == .light ? Color(.systemGray5) : Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .padding(.top, 20)

                            // Filter tyres
                            LazyVStack(alignment: .leading, spacing: 16) {
                                ForEach(filteredTyres.keys.sorted(), id: \.self) { category in
                                    DisclosureGroup(
                                        content: {
                                            // Rim sizes
                                            ForEach(filteredTyres[category]?.keys.sorted() ?? [], id: \.self) { rimSize in
                                                DisclosureGroup(
                                                    content: {
                                                        // Profiles
                                                        ForEach(filteredTyres[category]?[rimSize]?.keys.sorted() ?? [], id: \.self) { profile in
                                                            DisclosureGroup(
                                                                content: {
                                                                    // Width
                                                                    ForEach(filteredTyres[category]?[rimSize]?[profile]?.keys.sorted() ?? [], id: \.self) { speedRating in
                                                                        DisclosureGroup(
                                                                            content: {
                                                                                // Tyres
                                                                                ForEach(filteredTyres[category]?[rimSize]?[profile]?[speedRating] ?? [], id: \.self) { widthTyres in
                                                                                    ForEach(widthTyres, id: \.self) { tyre in
                                                                                        TyreCardView(tyre: tyre)
                                                                                    }
                                                                                }
                                                                            },
                                                                            label: {
                                                                                Text("Speed Rating: \(speedRating)")
                                                                                    .font(.subheadline)
                                                                                    .foregroundColor(.secondary)
                                                                                    .padding(.vertical, 4)
                                                                            }
                                                                        )
                                                                        .padding(.leading)
                                                                    }
                                                                },
                                                                label: {
                                                                    Text("Profile: \(profile)")
                                                                        .font(.subheadline)
                                                                        .foregroundColor(.secondary)
                                                                        .padding(.vertical, 4)
                                                                }
                                                            )
                                                            .padding(.leading)
                                                        }
                                                    },
                                                    label: {
                                                        Text("Rim Size: \(rimSize)")
                                                            .font(.subheadline)
                                                            .foregroundColor(.secondary)
                                                            .padding(.vertical, 4)
                                                    }
                                                )
                                                .padding(.leading)
                                            }

                                            // Add new tyre button
                                            Button(action: {
                                                addNewTyre(to: category)
                                            }) {
                                                HStack {
                                                    Spacer()
                                                    // Add new tyre icon
                                                    Image(systemName: "plus.circle.fill")
                                                        .font(.title2)
                                                        .foregroundColor(.blue)

                                                    // Add new tyre text
                                                    Text("Add New Tyre")
                                                        .font(.subheadline)
                                                        .foregroundColor(.blue)
                                                    Spacer()
                                                }
                                            }
                                            .padding(.vertical, 10)
                                        },
                                        label: {
                                            Text(category)
                                                .font(.headline)
                                                .fontWeight(.medium)
                                                .lineLimit(nil)
                                                .foregroundColor(.primary)
                                        }
                                    )
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(colorScheme == .light ? Color(.systemBackground) : Color(.systemGray6))
                                    )
                                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 16)
                        }
                    }
                }
            }
            .navigationTitle("Manage Products")
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .sheet(isPresented: $showingAddTyreSheet) {
                NavigationStack {
                    AddTyreView(category: selectedCategory)
                }
            }
        }
    }

    // MARK: - Helper Functions

    /// Filters and groups tyres based on the search criteria
    private var filteredTyres: [String: [String: [String: [String: [[Tyre]]]]]] {
        let filtered = tyres.filter {
            searchRimSize.isEmpty || "\($0.rimSize)".contains(searchRimSize)
        }

        let groupedByCategory = Dictionary(grouping: filtered, by: { $0.category })

        // Rim sizes
        return groupedByCategory.mapValues { categoryTyres in
            let groupedByRimSize = Dictionary(grouping: categoryTyres, by: { $0.rimSize })

            // Profiles
            return groupedByRimSize.mapValues { rimSizeTyres in
                let groupedByProfile = Dictionary(grouping: rimSizeTyres, by: { $0.profile })

                // Speed ratings
                return groupedByProfile.mapValues { profileTyres in
                    let groupedBySpeedRating = Dictionary(grouping: profileTyres, by: { $0.speedRating })

                    // Widths
                    return groupedBySpeedRating.mapValues { speedRatingTyres in
                        let groupedByWidth = Dictionary(grouping: speedRatingTyres, by: { $0.width })

                        // Filtered array
                        return groupedByWidth.keys.sorted().map { width in
                            groupedByWidth[width]?.sorted { $0.price < $1.price } ?? []
                        }
                    }
                }
            }
        }
    }

    // Adds a new tyre to the specified category
    private func addNewTyre(to category: String) {
        selectedCategory = category
        showingAddTyreSheet = true
    }
}

// MARK: - Tyre Card Struct

struct TyreCardView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var modelContext

    @State private var tyreManager: TyreManager?
    @State private var showingDeleteConfirmation = false
    @State private var showingEditSheet = false

    let tyre: Tyre

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                // Tyre image
                Text("\(tyre.brand) \(tyre.model)")
                    .font(.headline)
                    .fontWeight(.medium)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                if tyre.isWinter {
                    Image(systemName: "snowflake")
                        .foregroundColor(.blue)
                        .font(.subheadline)
                }
            }

            Divider()
                .padding(.vertical, 2)

            HStack(alignment: .top) {
                // Tyre specifications
                Text("\(tyre.width)/\(tyre.profile)R\(tyre.rimSize) \(tyre.speedRating)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                Spacer()

                // Price
                Text("£\(tyre.price, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(.primary)
            }

            HStack {
                // Edit button
                Button(action: {
                    showingEditSheet = true
                }) {
                    Text("Edit")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }

                Spacer()

                // Delete button
                Button(action: {
                    showingDeleteConfirmation = true
                }) {
                    Text("Delete")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                }
                .alert("Confirm Deletion", isPresented: $showingDeleteConfirmation) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        deleteTyre()
                    }
                } message: {
                    Text("Are you sure you want to delete this tyre?")
                }
            }
            .padding(.top, 4)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .light ? Color(.systemBackground) : Color(.systemGray5))
        )
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
        .padding(.horizontal, 4)
        .padding(.vertical, 4)
        .onAppear {
            if tyreManager == nil {
                tyreManager = TyreManager(context: modelContext)
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            NavigationStack {
                EditTyreView(tyre: tyre)
            }
        }
    }

    /// Deletes the selected tyre from the context
    private func deleteTyre() {
        tyreManager?.deleteTyre(tyre)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Tyre.self, configurations: config)

        // Add sample tyres
        let context = container.mainContext

        // Premium category
        let premiumTyre1 = Tyre(width: "225", profile: "45", rimSize: "18", brand: "Michelisdgdsfgdsgsdfgsdfgsdfgsdfgsdfgsdfgn", model: "Pilot Sport 4", speedRating: "Y", price: 120.99, isWinter: true, category: "Premium")
        let premiumTyre2 = Tyre(width: "245", profile: "40", rimSize: "19", brand: "Bridgestone", model: "Potenza", speedRating: "W", price: 135.50, isWinter: false, category: "Premium")
        let premiumWinter = Tyre(width: "225", profile: "45", rimSize: "18", brand: "Continental", model: "WinterContact", speedRating: "H", price: 145.99, isWinter: true, category: "Premium")

        //   category
        let economyTyre = Tyre(width: "205", profile: "55", rimSize: "16", brand: "Nankang", model: "NS-20", speedRating: "V", price: 65.99, isWinter: false, category: "Economy")
        let economyWinter = Tyre(width: "205", profile: "55", rimSize: "16", brand: "Jinyu", model: "Winter YW51", speedRating: "T", price: 75.50, isWinter: true, category: "Economy")

        // Midrange category
        let midRangeTyre = Tyre(width: "215", profile: "50", rimSize: "17", brand: "Hankook", model: "Ventus V12", speedRating: "V", price: 89.99, isWinter: false, category: "Midrange")

        context.insert(premiumTyre1)
        context.insert(premiumTyre2)
        context.insert(premiumWinter)
        context.insert(economyTyre)
        context.insert(economyWinter)
        context.insert(midRangeTyre)

        return ManageProductsView()
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
