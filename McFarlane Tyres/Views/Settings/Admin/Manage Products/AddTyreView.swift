//
//  AddTyreView.swift
//  McFarlane Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This view allows users to add a new tyre to the database with all relevant specifications.
//

import SwiftData
import SwiftUI

struct AddTyreView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @State private var brand: String = ""
    @State private var model: String = ""
    @State private var width: String = ""
    @State private var profile: String = ""
    @State private var rimSize: String = ""
    @State private var speedRating: String = ""
    @State private var price: Double = 0.0
    @State private var isWinter: Bool = false
    @State private var selectedCategory: String = ""

    @State private var showAlert = false
    @State private var alertMessage = ""

    let speedRatings = ["H", "T", "V", "W", "Y", "Z"]
    let categories = ["Economy", "Midrange", "Premium"]

    // Initializer to set the selected category
    init(category: String) {
        _selectedCategory = State(initialValue: category)
    }

    var body: some View {
        NavigationStack {
            Form {
                // Tyre details
                Section(header: Text("Basic Information")) {
                    TextField("Brand", text: $brand)
                    TextField("Model", text: $model)
                    Toggle("Winter Tyre", isOn: $isWinter)

                    Picker("Category", selection: $selectedCategory) {
                        if selectedCategory.isEmpty {
                            Text("Select").tag("")
                        }
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                    .accentColor(selectedCategory.isEmpty ? .secondary : .primary)
                }

                // Specifications section
                Section(header: Text("Specifications")) {
                    TextField("Width", text: $width)
                        .keyboardType(.numberPad)

                    TextField("Profile", text: $profile)
                        .keyboardType(.numberPad)

                    TextField("Rim Size", text: $rimSize)
                        .keyboardType(.numberPad)

                    Picker("Speed Rating", selection: $speedRating) {
                        if speedRating.isEmpty {
                            Text("Select").tag("")
                        }
                        ForEach(speedRatings, id: \.self) { rating in
                            Text(rating).tag(rating)
                        }
                    }
                    .pickerStyle(.menu)
                    .accentColor(speedRating.isEmpty ? .secondary : .primary)
                }

                // Pricing
                Section(header: Text("Pricing")) {
                    HStack {
                        Text("£")
                        TextField("Price", value: $price, format: .number)
                            .keyboardType(.decimalPad)
                    }
                }
            }
            .navigationTitle("Add New Tyre")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTyre()
                    }
                    .disabled(!isFormValid)
                }
            }
            .alert("Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
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

    // Save the tyre to the database
    private func saveTyre() {
        let tyreManager = TyreManager(context: context)

        tyreManager.addTyre(
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

// MARK: - Preview

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Tyre.self, configurations: config)

        return NavigationStack {
            AddTyreView(category: "")
                .modelContainer(container)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
