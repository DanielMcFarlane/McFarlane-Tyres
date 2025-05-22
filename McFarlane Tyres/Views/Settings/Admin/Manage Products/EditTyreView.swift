//
//  EditTyreView.swift
//  McFarlane Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This view allows the user to edit the details of a tyre.
//

import SwiftData
import SwiftUI

struct EditTyreView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @Bindable var tyre: Tyre

    @State private var brand: String
    @State private var model: String
    @State private var width: String
    @State private var profile: String
    @State private var rimSize: String
    @State private var speedRating: String
    @State private var price: Double
    @State private var isWinter: Bool
    @State private var selectedCategory: String
    @State private var showAlert = false
    @State private var alertMessage = ""

    let speedRatings = ["H", "T", "V", "W", "Y", "Z"]
    let categories = ["Economy", "Midrange", "Premium"]

    // Initializer to set up the tyre details
    init(tyre: Tyre) {
        self.tyre = tyre
        _brand = State(initialValue: tyre.brand)
        _model = State(initialValue: tyre.model)
        _width = State(initialValue: tyre.width)
        _profile = State(initialValue: tyre.profile)
        _rimSize = State(initialValue: tyre.rimSize)
        _speedRating = State(initialValue: tyre.speedRating)
        _price = State(initialValue: tyre.price)
        _isWinter = State(initialValue: tyre.isWinter)
        _selectedCategory = State(initialValue: tyre.category)
    }

    var body: some View {
        NavigationStack {
            Form {
                // Tyre details
                Section(header: Text("Tyre Information")) {
                    TextField("Brand", text: $brand)
                    TextField("Model", text: $model)
                    Toggle("Winter Tyre", isOn: $isWinter)

                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                    .accentColor(.primary)
                }

                // Tyre specifications
                Section(header: Text("Specifications")) {
                    TextField("Width", text: $width)
                        .keyboardType(.numberPad)
                        .onChange(of: width) { _, newValue in
                            width = newValue.filter { $0.isNumber }
                        }

                    TextField("Profile", text: $profile)
                        .keyboardType(.numberPad)
                        .onChange(of: profile) { _, newValue in
                            profile = newValue.filter { $0.isNumber }
                        }

                    TextField("Rim Size", text: $rimSize)
                        .keyboardType(.numberPad)
                        .onChange(of: rimSize) { _, newValue in
                            rimSize = newValue.filter { $0.isNumber }
                        }

                    Picker("Speed Rating", selection: $speedRating) {
                        ForEach(speedRatings, id: \.self) { rating in
                            Text(rating).tag(rating)
                        }
                    }
                    .pickerStyle(.menu)
                    .accentColor(.primary)
                }

                // Pricing
                Section(header: Text("Pricing")) {
                    HStack {
                        Text("£")
                        TextField("Price", value: $price, format: .number)
                            .keyboardType(.decimalPad)
                            .onChange(of: price) { _, newValue in
                                if newValue < 0 {
                                    price = 0
                                }
                            }
                    }
                }
            }
            .navigationTitle("Edit Tyre")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        updateTyre()
                    }
                    .disabled(!isFormValid)
                }
            }
            .alert("Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .background(Color(.systemBackground))
        .onTapGesture {
            hideKeyboard()
        }
    }

    // MARK: - Helper Functions

    // Input validation
    var isFormValid: Bool {
        !brand.isEmpty &&
            !model.isEmpty &&
            !width.isEmpty &&
            !profile.isEmpty &&
            !rimSize.isEmpty &&
            !speedRating.isEmpty &&
            price > 0
    }

    // Update the tyre in the database
    private func updateTyre() {
        let tyreManager = TyreManager(context: context)

        tyreManager.updateTyre(
            tyre: tyre,
            width: width,
            profile: profile,
            rimSize: rimSize,
            brand: brand,
            model: model,
            speedRating: speedRating,
            price: price,
            isWinter: isWinter,
            category: selectedCategory
        )
        dismiss()
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Tyre.self, configurations: config)

        let sampleTyre = Tyre(
            width: "225",
            profile: "45",
            rimSize: "18",
            brand: "Michelin",
            model: "Pilot Sport 4",
            speedRating: "Y",
            price: 120.99,
            isWinter: true,
            category: "Premium"
        )

        let context = container.mainContext
        context.insert(sampleTyre)

        return NavigationStack {
            EditTyreView(tyre: sampleTyre)
                .modelContainer(container)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
