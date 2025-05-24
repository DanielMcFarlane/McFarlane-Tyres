//
//  ManageTyresView.swift
//  McFarlane's Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This view allows admins to manage products.
//

import SwiftData
import SwiftUI

struct ManageTyresView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) var colorScheme

    @Query(sort: [SortDescriptor(\Tyre.rimSize), SortDescriptor(\Tyre.profile), SortDescriptor(\Tyre.width)]) private var tyres: [Tyre]

    @State private var searchBar: String = ""
    @State private var showingAddTyreSheet = false
    @State private var selectedCategory = ""

    var body: some View {
        NavigationStack {
            List {
                // Search bar
                Section {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        TextField("Search tyres...", text: $searchBar)
                            .font(.subheadline)
                            .disableAutocorrection(true)
                    }
                    .padding(.vertical, 6)
                }

                // Show no tyres found message if filteredTyres is empty
                if filteredTyres.isEmpty {
                    Text("No tyres found")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .multilineTextAlignment(.center)
                        .padding()
                        .listRowBackground(Color.clear)
                } else {
                    // Tyre categories - this probably kills performance but it works
                    ForEach(filteredTyres.keys.sorted(), id: \.self) { category in
                        Section(header: Text(category).font(.headline)) {
                            ForEach(filteredTyres[category]?.keys.sorted() ?? [], id: \.self) { rimSize in
                                DisclosureGroup("Rim Size: \(rimSize)") {
                                    ForEach(filteredTyres[category]?[rimSize]?.keys.sorted() ?? [], id: \.self) { profile in
                                        DisclosureGroup("Profile: \(profile)") {
                                            ForEach(filteredTyres[category]?[rimSize]?[profile]?.keys.sorted() ?? [], id: \.self) { speedRating in
                                                DisclosureGroup("Speed Rating: \(speedRating)") {
                                                    ForEach(filteredTyres[category]?[rimSize]?[profile]?[speedRating] ?? [], id: \.self) { widthTyres in
                                                        ForEach(widthTyres, id: \.self) { tyre in
                                                            HStack {
                                                                TyreCardView(tyre: tyre)
                                                                    .frame(maxWidth: .infinity, alignment: .center)
                                                            }
                                                            .listRowInsets(EdgeInsets(top: 0, leading: -30, bottom: 0, trailing: 30))
                                                            .listRowSeparator(.hidden)
                                                            .shadow(color: .black.opacity(0.06), radius: 5, x: 0, y: 0)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            // Add new tyre button
                            Button(action: {
                                addNewTyre(to: category)
                            }) {
                                HStack {
                                    Spacer()
                                    Image(systemName: "plus.circle.fill")
                                        .font(.body)
                                        .foregroundColor(.blue)
                                    Text("Add New Tyre")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                    Spacer()
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
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

    /// Filters the list of tyres based on the search bar input
    private func filterTyres(with search: String) -> [Tyre] {
        let search = search.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        if search.isEmpty {
            return tyres
        }

        /// Checks if a text has a prefix
        func prefixSearch(_ text: String, prefix: String) -> Bool {
            text.lowercased().hasPrefix(prefix)
        }

        /// Checks if a word is a prefix in the tyre fields
        func wordMatchesTyrePrefix(_ word: String, tyre: Tyre) -> Bool {
            prefixSearch(tyre.brand, prefix: word) ||
                prefixSearch(tyre.model, prefix: word) ||
                tyre.width.lowercased().hasPrefix(word) ||
                tyre.profile.lowercased().hasPrefix(word) ||
                tyre.rimSize.lowercased().hasPrefix(word) ||
                prefixSearch(tyre.speedRating, prefix: word) ||
                (word == "winter" && tyre.isWinter)
        }

        /// Checks if all words in the search are prefixes in the tyre fields
        func allWordsMatchPrefix(_ words: [String], tyre: Tyre) -> Bool {
            words.allSatisfy { wordMatchesTyrePrefix($0, tyre: tyre) }
        }

        if search.contains("/") {
            let filteredSearch = search.replacingOccurrences(of: " ", with: "/")
            let sizeComponents = filteredSearch.split(separator: "/").map(String.init)

            switch sizeComponents.count {
            case 4:
                let (width, profile, rim, speed) = (sizeComponents[0], sizeComponents[1], sizeComponents[2], sizeComponents[3].uppercased())

                return tyres.filter {
                    $0.width.hasPrefix(width) &&
                        $0.profile.hasPrefix(profile) &&
                        $0.rimSize.hasPrefix(rim) &&
                        $0.speedRating.uppercased().hasPrefix(speed)
                }

            case 3:
                let (width, profile, rim) = (sizeComponents[0], sizeComponents[1], sizeComponents[2])

                return tyres.filter {
                    $0.width.hasPrefix(width) &&
                        $0.profile.hasPrefix(profile) &&
                        $0.rimSize.hasPrefix(rim)
                }

            case 2:
                let (width, profile) = (sizeComponents[0], sizeComponents[1])

                return tyres.filter {
                    $0.width.hasPrefix(width) &&
                        $0.profile.hasPrefix(profile)
                }

            case 1:
                let width = sizeComponents[0]

                return tyres.filter {
                    $0.width.hasPrefix(width)
                }

            default:
                return tyres.filter {
                    let fullSize = "\($0.width)/\($0.profile)/\($0.rimSize)/\($0.speedRating.uppercased())"

                    return prefixSearch($0.brand, prefix: search) ||
                        prefixSearch($0.model, prefix: search) ||
                        prefixSearch(fullSize, prefix: search) ||
                        prefixSearch($0.rimSize, prefix: search) ||
                        prefixSearch($0.profile, prefix: search) ||
                        prefixSearch($0.speedRating, prefix: search) ||
                        prefixSearch($0.width, prefix: search) ||
                        (search.contains("winter") && $0.isWinter)
                }
            }
        } else {
            let searchWords = search.split(separator: " ").map(String.init)

            return tyres.filter { tyre in
                allWordsMatchPrefix(searchWords, tyre: tyre)
            }
        }
    }

    /// Group tyres into a nested dictionary
    private func groupTyres(_ tyres: [Tyre]) -> [String: [String: [String: [String: [[Tyre]]]]]] {
        Dictionary(grouping: tyres, by: \.category)
            .mapValues { categoryGroup in
                Dictionary(grouping: categoryGroup, by: \.rimSize)
                    .mapValues { rimGroup in
                        Dictionary(grouping: rimGroup, by: \.profile)
                            .mapValues { profileGroup in
                                Dictionary(grouping: profileGroup, by: \.speedRating)
                                    .mapValues { speedGroup in
                                        Dictionary(grouping: speedGroup, by: \.width)
                                            .keys.sorted().map { width in
                                                Dictionary(grouping: speedGroup, by: \.width)[width]?.sorted(by: { $0.price < $1.price }) ?? []
                                            }
                                    }
                            }
                    }
            }
    }

    /// Filtered from the search bar input
    private var filteredTyres: [String: [String: [String: [String: [[Tyre]]]]]] {
        let search = searchBar.trimmingCharacters(in: .whitespacesAndNewlines)
        let filtered = filterTyres(with: search)
        return groupTyres(filtered)
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
                Text("\(tyre.width)/\(tyre.profile)/\(tyre.rimSize) \(tyre.speedRating)")
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
                        .frame(minWidth: 60)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
                .simultaneousGesture(TapGesture())
                .allowsHitTesting(true)

                Spacer()

                // Delete button
                Button(action: {
                    showingDeleteConfirmation = true
                }) {
                    Text("Delete")
                        .font(.caption)
                        .foregroundColor(.red)
                        .frame(minWidth: 60)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
                .simultaneousGesture(TapGesture())
                .allowsHitTesting(true)
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
        .contentShape(Rectangle())
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
        let premiumTyre1 = Tyre(width: "225", profile: "45", rimSize: "18", brand: "Michelin", model: "Pilot Sport 4", speedRating: "Y", price: 120.99, isWinter: true, category: "Premium")
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

        return ManageTyresView()
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
