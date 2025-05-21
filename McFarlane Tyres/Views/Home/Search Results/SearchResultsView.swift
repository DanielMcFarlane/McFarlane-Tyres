//
//  SearchResultsView.swift
//  McFarlane's Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This view displays the results of a tyre search showing tyres sorted by category and price.
//

import SwiftData
import SwiftUI

struct SearchResultsView: View {
    @Environment(\.colorScheme) var colorScheme

    var tyres: [Tyre]

    @State private var showingPopUp = false
    @State private var popUpMessage = ""

    // Sorts the tyres by category and then by price within each category
    private var sortedTyres: [Tyre] {
        let categoryOrder = ["economy", "midrange", "premium"]

        return tyres.sorted {
            let category1 = categoryOrder.firstIndex(of: $0.category.lowercased()) ?? Int.max
            let category2 = categoryOrder.firstIndex(of: $1.category.lowercased()) ?? Int.max

            return category1 == category2 ? $0.price < $1.price : category1 < category2
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    ZStack {
                        ScrollView {
                            VStack(spacing: 0) {
                                // Title
                                Text("Search Results")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding(.top, 20)

                                if tyres.isEmpty {
                                    // No tyres found view
                                    Text("No tyres found.")
                                        .font(.title3)
                                        .foregroundColor(.secondary)
                                        .padding()
                                } else {
                                    // Group tyres by category
                                    LazyVStack(spacing: 20) {
                                        ForEach(sortedTyres, id: \.id) { tyre in
                                            SearchCard(tyre: tyre, showPopUp: showPopUpNotification)
                                                .frame(maxWidth: .infinity)
                                                .padding(.horizontal, 20)
                                        }
                                    }
                                    .padding(.top)
                                    .padding(.bottom, 16)
                                }
                            }
                        }
                    }
                    TaskBarView(currentView: "searchResults")
                }
                .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())

                // Pop up notification
                if showingPopUp {
                    VStack {
                        Spacer()
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(popUpMessage)
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                        }
                        .padding()
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
                        .background(colorScheme == .light ? Color.black.opacity(0.7) : Color(UIColor.systemGray6).opacity(0.7))
                        .cornerRadius(10)
                        .padding(.bottom, 80)
                    }
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: showingPopUp)
                    .zIndex(1)
                }
            }
        }
    }

    // MARK: - Helper Functions

    /// Shows a pop-up notification with the given message
    func showPopUpNotification(message: String) {
        popUpMessage = message
        showingPopUp = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Hide the pop-up after 2 seconds
            withAnimation {
                showingPopUp = false
            }
        }
    }
}

#Preview {
    let sampleTyres = [
        Tyre(width: "205",
             profile: "55",
             rimSize: "16",
             brand: "Michelin",
             model: "Primacy 4",
             speedRating: "V",
             price: 89.99,
             isWinter: false,
             category: "Premium"
        ),
        Tyre(width: "205",
             profile: "55",
             rimSize: "16",
             brand: "Michelin",
             model: "Primacy 4",
             speedRating: "V",
             price: 89.99,
             isWinter: false,
             category: "Premium"
        ),
        Tyre(width: "205",
             profile: "55",
             rimSize: "16",
             brand: "Michelin",
             model: "Primacy 4",
             speedRating: "V",
             price: 89.99,
             isWinter: false,
             category: "Premium"
        ),
        Tyre(width: "195",
             profile: "65",
             rimSize: "15",
             brand: "Goodyear",
             model: "EfficientGrip Performance",
             speedRating: "H",
             price: 74.50,
             isWinter: true,
             category: "Economy"
        ),
    ]
    SearchResultsView(tyres: sampleTyres)
        .modelContainer(for: [
            User.self,
            Tyre.self,
            BasketItem.self,
            Order.self,
            OrderLine.self,
        ]
        , inMemory: true)
}
