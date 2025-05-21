//
//  HomeView.swift
//  McFarlane's Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This view allows users to search for tyres based on size filters and displays tyre details.
//

import SwiftData
import SwiftUI

// A tyre filter struct simplifies the process of managing tyre filters
struct TyreFilters: Equatable {
    var widths: [String] = []
    var profiles: [String] = []
    var rimSizes: [String] = []
    var speedRatings: [String] = []

    var selectedWidth = "205"
    var selectedProfile = "55"
    var selectedRimSize = "16"
    var selectedSpeed = "V"

    var sortByPriceAscending = true
}

struct HomeView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) var colorScheme

    @State private var tyreFilters = TyreFilters()
    @State private var showAccountView = false
    @State private var searchResults: [Tyre] = []

    private var tyreManager: TyreManager { TyreManager(context: context) }

    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 30) {
                        // Logo
                        VStack(alignment: .trailing, spacing: -16) {
                            Text("MCFARLANE'S")
                                .font(.custom("AvenirNext-Bold", size: 44))
                                .foregroundColor(Color.primary)
                                .italic()
                                .kerning(2)

                            Text("TYRES")
                                .font(.custom("AvenirNext-Bold", size: 25))
                                .foregroundColor(Color.primary)
                                .italic()
                                .kerning(2)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal)

                        // Tyre picker
                        VStack(spacing: 16) {
                            // Title
                            Text("Find tyres by size")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color(UIColor.label))
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            // Tyre picker drop downs
                            HStack(spacing: 9) {
                                tyrePicker(title: "Width", selection: $tyreFilters.selectedWidth, options: tyreFilters.widths)
                                tyrePicker(title: "Profile", selection: $tyreFilters.selectedProfile, options: tyreFilters.profiles)
                                tyrePicker(title: "Rim Size", selection: $tyreFilters.selectedRimSize, options: tyreFilters.rimSizes)
                                tyrePicker(title: "Speed", selection: $tyreFilters.selectedSpeed, options: tyreFilters.speedRatings)
                            }
                            
                            Divider()
                                .background(Color.gray)
                                .padding(.horizontal, 44)
                                .padding(.top, 6)

                            // Tyre description image
                            Image(colorScheme == .dark ? "Tyre-Description-Dark-Mode" : "Tyre-Description-Light-Mode")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 370, height: 124)
                                .padding(.bottom, 16)

                            // Search button
                            NavigationLink(destination: SearchResultsView(tyres: fetchFilteredTyres())) {
                                Text("Search by size")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(red: 8 / 255, green: 31 / 255, blue: 92 / 255)) // #081F5C
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal, 30)
                        }
                        .padding()
                        .background(.ultraThinMaterial.opacity(0.9))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                        .padding(.horizontal, 20)

                        Divider()
                            .padding(.horizontal, 64)

                        // Body text
                        Text("Why Choose Us?")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.bottom, -12)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(Color.primary)

                        // Description text
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Browse a wide range of tyres for your vehicle")
                            }
                            .padding(.horizontal)

                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Flexible fitting times to suit your schedule")
                            }
                            .padding(.horizontal)

                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Transparent pricing with no hidden fees")
                            }
                            .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Add padding at bottom to account for task bar
                        Spacer(minLength: 80)
                    }
                    .padding(.top, 50)
                }
                .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
                .navigationBarHidden(true)
            }
            
            // Task bar is positioned at the bottom using ZStack
            TaskBarView(currentView: "home")
                .background(Color(UIColor.systemBackground))
        }
        .onAppear {
            loadTyres()

            if UserManager(context: context).fetchUsers().isEmpty {
                UserManager(context: context).loadDefaultUsers()
            }
        }
        .onChange(of: tyreFilters.selectedWidth) {
            updateProfiles()
        }
        .onChange(of: tyreFilters.selectedProfile) {
            updateRimSizes()
        }
        .onChange(of: tyreFilters.selectedRimSize) {
            updateSpeedRatings()
        }
    }
    // MARK: - Helper functions

    /// Picker for tyre filters
    func tyrePicker(title: String, selection: Binding<String>, options: [String]) -> some View {
        VStack(alignment: .center, spacing: 8) {
            Text(title)
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Picker(title, selection: selection) {
                ForEach(options, id: \.self) { option in
                    Text(option)
                        .font(.body)
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity)
            .padding(2)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
        }
        .frame(maxWidth: 84)
    }
    
    /// Loads default tyres if none exist and fetches tyre data from the database
    private func loadTyres() {
        if tyreManager.fetchTyres().isEmpty {
            tyreManager.loadDefaultTyres()
        }

        tyreFilters.widths = Array(Set(tyreManager.fetchTyres().map { $0.width })).sorted()

        if !tyreFilters.widths.contains(tyreFilters.selectedWidth) {
            tyreFilters.selectedWidth = tyreFilters.widths.first ?? ""
        }

        updateTyrePicker()
    }

    /// Updates the tyre picker options based on selected width, profile and rim size
    private func updateTyrePicker() {
        tyreFilters.profiles = tyreManager.fetchProfiles(forWidth: tyreFilters.selectedWidth)
        if !tyreFilters.profiles.contains(tyreFilters.selectedProfile) {
            tyreFilters.selectedProfile = tyreFilters.profiles.first ?? ""
        }

        tyreFilters.rimSizes = tyreManager.fetchRimSizes(
            forWidth: tyreFilters.selectedWidth,
            andProfile: tyreFilters.selectedProfile
        )
        if !tyreFilters.rimSizes.contains(tyreFilters.selectedRimSize) {
            tyreFilters.selectedRimSize = tyreFilters.rimSizes.first ?? ""
        }

        tyreFilters.speedRatings = tyreManager.fetchSpeedRatings(
            forWidth: tyreFilters.selectedWidth,
            profile: tyreFilters.selectedProfile,
            rimSize: tyreFilters.selectedRimSize
        )
        if !tyreFilters.speedRatings.contains(tyreFilters.selectedSpeed) {
            tyreFilters.selectedSpeed = tyreFilters.speedRatings.first ?? ""
        }
    }

    /// Updates the profiles based on selected width
    private func updateProfiles() {
        tyreFilters.profiles = tyreManager.fetchProfiles(forWidth: tyreFilters.selectedWidth)
        tyreFilters.selectedProfile = tyreFilters.profiles.first ?? ""

        updateRimSizes()
    }

    /// Updates the rim sizes based on selected width and profile
    private func updateRimSizes() {
        tyreFilters.rimSizes = tyreManager.fetchRimSizes(forWidth: tyreFilters.selectedWidth, andProfile: tyreFilters.selectedProfile)
        tyreFilters.selectedRimSize = tyreFilters.rimSizes.first ?? ""

        updateSpeedRatings()
    }

    /// Updates the speed ratings based on selected width, profile and rim size
    private func updateSpeedRatings() {
        tyreFilters.speedRatings = tyreManager.fetchSpeedRatings(forWidth: tyreFilters.selectedWidth, profile: tyreFilters.selectedProfile, rimSize: tyreFilters.selectedRimSize)

        if tyreFilters.speedRatings.contains("Any") {
            tyreFilters.selectedSpeed = "Any"
        } else {
            tyreFilters.selectedSpeed = tyreFilters.speedRatings.first ?? ""
        }
    }

    /// Fetches filtered tyres based on selected filters
    private func fetchFilteredTyres() -> [Tyre] {
        var results = tyreManager.searchTyres(
            width: tyreFilters.selectedWidth,
            profile: tyreFilters.selectedProfile,
            rimSize: tyreFilters.selectedRimSize,
            speed: tyreFilters.selectedSpeed
        )

        if tyreFilters.sortByPriceAscending {
            results.sort { $0.price < $1.price }
        } else {
            results.sort { $0.price > $1.price }
        }
        return results
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [
            User.self,
            Tyre.self,
            BasketItem.self,
            Order.self,
            OrderLine.self,
        ]
        , inMemory: true)
}
