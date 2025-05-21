//
//  CheckoutView.swift
//  McFarlane's Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This view allows the user to review their selected tyre, provide customer, payment details and complete the checkout process.
//

import Combine
import SwiftData
import SwiftUI

struct CheckoutView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var context

    @Query private var users: [User]

    @State private var cardName = ""
    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var customerName = ""
    @State private var carReg = ""
    @State private var orderNumber = ""
    @State private var bookingDate = Date()
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var navigateToConfirmation = false

    @FocusState private var activeField: Field?

    var basketItems: [BasketItem]

    // Enum for identifying the text fields
    enum Field: Hashable {
        case customerName, carReg, cardName, cardNumber, expiryDate, cvv
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: - Checkout Card

                    // Title
                    Text("Checkout")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 20)

                    // Checkout card
                    CheckoutCard(basketItems: basketItems)

                    Divider()
                        .padding(.vertical)
                        .padding(.horizontal, 64)

                    // Instructions
                    Text("Please enter your details and provide payment information to complete your purchase")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.bottom)

                    customerDetailsCard
                    paymentDetailsCard

                    Spacer()

                    // MARK: - Checkout Button

                    // Complete checkout button
                    Button {
                        let validationError = validateFields()
                        if let error = validationError {
                            errorMessage = error
                            showError = true
                        } else {
                            let lastOrderNumber = fetchLastOrderNumber()
                            orderNumber = String(format: "Order # %06d", lastOrderNumber + 1)
                            processCheckout()
                            navigateToConfirmation = true
                        }
                    } label: {
                        Text("Complete Checkout")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 8 / 255, green: 31 / 255, blue: 92 / 255))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20)
                    .alert("Checkout Error", isPresented: $showError) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text(errorMessage ?? "Something went wrong.")
                    }
                }
                .padding(.horizontal, 14)
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
            .ignoresSafeArea(.keyboard, edges: .top)
            .onTapGesture {
                hideKeyboard()
            }
            .fullScreenCover(isPresented: $navigateToConfirmation) {
                OrderConfirmationView(
                    basketItems: basketItems,
                    bookingDate: bookingDate,
                    orderNumber: orderNumber,
                    customerName: customerName,
                    carRegistration: carReg
                )
            }
        }
    }

    // MARK: - Details Cards

    // Customer details card
    private var customerDetailsCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Title
            Text("Customer Details")
                .font(.headline)
                .padding(.bottom, 5)

            // Customer name
            Text("Customer Name")
                .font(.subheadline)
                .foregroundColor(.secondary)

            // Text field for customer name
            TextField("Customer Name", text: $customerName)
                .focused($activeField, equals: .customerName)
                .textContentType(.name)
                .autocapitalization(.words)
                .onChange(of: customerName) { _, newValue in
                    customerName = newValue.filter { $0.isLetter || $0.isWhitespace }
                }
                .padding()
                .frame(height: 44)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
                .foregroundColor(Color(UIColor.label))

            HStack(spacing: 15) {
                VStack(alignment: .leading) {
                    // Title
                    Text("Car Registration")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    // Text field for car registration
                    TextField("Car Registration", text: $carReg)
                        .focused($activeField, equals: .carReg)
                        .onChange(of: carReg) { _, newValue in
                            carReg = String(newValue.uppercased().prefix(8))
                        }
                        .padding()
                        .frame(height: 44)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
                        .foregroundColor(Color(UIColor.label))
                }

                VStack(alignment: .center) {
                    // Title
                    Text("Booking Date")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    // Date picker for booking date
                    DatePicker("", selection: $bookingDate, in: {
                        #if DEBUG
                            ...Date.distantFuture
                        #else
                            Date()...
                        #endif
                    }(), displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .padding()
                        .frame(height: 44)
                        .foregroundColor(Color(UIColor.label))
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.12), radius: 5, x: 0, y: 2)
    }

    // Payment details card
    private var paymentDetailsCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Title
            Text("Payment Details")
                .font(.headline)
                .padding(.bottom, 5)

            // Name on card
            Text("Name on Card")
                .font(.subheadline)
                .foregroundColor(.secondary)

            // Text field for name on card
            TextField("Name on Card", text: $cardName)
                .focused($activeField, equals: .cardName)
                .textContentType(.creditCardName)
                .autocapitalization(.words)
                .onChange(of: cardName) { _, newValue in
                    cardName = newValue.filter { $0.isLetter || $0.isWhitespace }
                }
                .padding()
                .frame(height: 44)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
                .foregroundColor(Color(UIColor.label))

            // Card number
            Text("Card Number")
                .font(.subheadline)
                .foregroundColor(.secondary)

            // Card number text field
            TextField("Card Number", text: $cardNumber)
                .focused($activeField, equals: .cardNumber)
                .textContentType(.creditCardNumber)
                .keyboardType(.numberPad)
                .onChange(of: cardNumber) { _, newValue in
                    let digits = newValue.filter { $0.isNumber }
                    let truncated = String(digits.prefix(16))
                    cardNumber = truncated.replacingOccurrences(of: "(\\d{4})(?=\\d)", with: "$1-", options: .regularExpression)
                }
                .padding()
                .frame(height: 44)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
                .foregroundColor(Color(UIColor.label))

            HStack {
                VStack(alignment: .leading) {
                    // Title
                    Text("Expiry Date")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    // Expiry date text field
                    TextField("(MM/YY)", text: $expiryDate)
                        .focused($activeField, equals: .expiryDate)
                        .keyboardType(.numberPad)
                        .textContentType(.creditCardExpiration)
                        .onChange(of: expiryDate) { _, newValue in
                            expiryDate = formatExpiryDate(newValue)
                        }
                        .padding()
                        .frame(height: 44)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
                        .foregroundColor(Color(UIColor.label))
                }

                VStack(alignment: .leading) {
                    // Title
                    Text("CVV")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    // CVV text field
                    TextField("CVV", text: $cvv)
                        .focused($activeField, equals: .cvv)
                        .textContentType(.creditCardSecurityCode)
                        .keyboardType(.numberPad)
                        .onChange(of: cvv) { _, newValue in
                            cvv = String(newValue.filter(\.isNumber).prefix(3))
                        }
                        .padding()
                        .frame(height: 44)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
                        .foregroundColor(Color(UIColor.label))
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.12), radius: 5, x: 0, y: 2)
    }

    // M MARK: - Checkout Process
    ///  Processes the checkout by validating fields
    private func processCheckout() {
        // Validate fields
        if let error = validateFields() {
            errorMessage = error
            showError = true

            return
        }

        // Early exit to check if a user is logged in
        guard let user = users.first(where: { $0.loggedIn }) else {
            errorMessage = "No user is logged in."
            showError = true

            return
        }

        let tyres = basketItems.map { (tyre: $0.tyre, quantity: $0.quantity, fittingDate: bookingDate) }
        let orderManager = OrderManager(context: context)

        let lastOrderNumber = fetchLastOrderNumber()
        let nextOrderNumber = String(format: "Order # %06d", lastOrderNumber + 1)

        orderManager.createOrder(
            for: user,
            with: tyres,
            orderNumber: nextOrderNumber,
            customerName: customerName,
            carRegistration: carReg
        )

        // Clear basket
        BasketManager(context: context).clearBasket(for: user)

        orderNumber = nextOrderNumber
        navigateToConfirmation = true
    }

    // MARK: - Helper Functions

    private func validateFields() -> String? {
        // Empty fields check
        if customerName.isEmpty || carReg.isEmpty || cardName.isEmpty ||
            cardNumber.isEmpty || expiryDate.isEmpty || cvv.isEmpty {
            return "All fields are required."
        }

        // Card number validation
        if !isValidCardNumber(cardNumber) {
            return "Invalid card number format."
        }

        // Expiry date validation
        if !isValidExpiryDate(expiryDate) {
            return "Invalid expiry date format."
        }

        // CVV validation
        if !isValidCVV(cvv) {
            return "Invalid CVV format."
        }

        return nil
    }

    /// Fetches the last order number from the database
    private func fetchLastOrderNumber() -> Int {
        let orderLines = try? context.fetch(FetchDescriptor<OrderLine>())

        return orderLines?
            .compactMap { Int($0.orderNumber.replacingOccurrences(of: "Order # ", with: "")) }
            .max() ?? 0
    }

    /// Validates the card number format
    private func isValidCardNumber(_ number: String) -> Bool {
        let unformattedNumber = number.replacingOccurrences(of: "-", with: "")
        return NSPredicate(format: "SELF MATCHES %@", "^[0-9]{16}$").evaluate(with: unformattedNumber)
    }

    /// Validates the expiry date format
    private func isValidExpiryDate(_ date: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", "^(0[1-9]|1[0-2])/[0-9]{2}$").evaluate(with: date)
    }

    /// Validates the CVV format
    private func isValidCVV(_ cvv: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", "^[0-9]{3,4}$").evaluate(with: cvv)
    }

    /// Formats the expiry date to MM/YY
    private func formatExpiryDate(_ input: String) -> String {
        let digits = input.filter { $0.isNumber }

        if digits.count >= 3 {
            let month = digits.prefix(2)
            let year = digits.suffix(from: digits.index(digits.startIndex, offsetBy: 2))

            return "\(month)/\(year.prefix(2))"
        } else if digits.count <= 2 {
            return digits
        }
        return ""
    }

    /// Hide keyboard function
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    @Previewable @State var quantity1 = 2
    @Previewable @State var quantity2 = 1

    let tyre1 = Tyre(
        width: "225",
        profile: "45",
        rimSize: "17",
        brand: "Pirelli",
        model: "Cinturato P7",
        speedRating: "W",
        price: 102.50,
        isWinter: false,
        category: "Premium"
    )

    let tyre2 = Tyre(
        width: "195",
        profile: "65",
        rimSize: "15",
        brand: "Michelin",
        model: "Energy Saver",
        speedRating: "H",
        price: 85.99,
        isWinter: true,
        category: "Standard"
    )

    CheckoutView(basketItems: [
        BasketItem(tyre: tyre1, quantity: quantity1),
        BasketItem(tyre: tyre2, quantity: quantity2),
    ])
    .modelContainer(for: [
        User.self,
        Tyre.self,
        BasketItem.self,
        Order.self,
        OrderLine.self,
    ], inMemory: true)
}
