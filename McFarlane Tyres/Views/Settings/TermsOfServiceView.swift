//
//  TermsOfServiceView.swift
//  McFarlane's Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This view displays the Terms of Service for the application.
//

import SwiftUI

// A Term struct allows better readability of the terms
struct Term {
    let title: String
    let content: String
}

struct TermsOfServiceView: View {
    @Environment(\.colorScheme) var colorScheme

    private let termsItems = [
        Term(
            title: "1. The Agreement Between Us",
            content: "This website allows you to explore various products and services online and to schedule a booking for later delivery and installation. A contract will be formed once you complete the payment for services and products as advertised on this website."
        ),
        Term(
            title: "2. Ownership of Rights",
            content: "All rights, including copyright, for this website are held by or licensed to the service provider. Any use of this website or its contents, including reproduction or storage, other than for personal, non-commercial use, is prohibited without prior approval."
        ),
        Term(
            title: "3. Content Accuracy",
            content: "We have carefully prepared the content of this website, ensuring that prices are accurate at the time of publication and that the products are described fairly. However, bookings will only be accepted if there are no significant errors in the product descriptions or prices as listed on the website."
        ),
        Term(
            title: "4. Risk of Computer Damage",
            content: "We make every effort to ensure this website is free from viruses or other defects. However, we cannot guarantee that using this website or any linked sites will not result in damage to your device."
        ),
        Term(
            title: "5. Availability",
            content: "All bookings are subject to acceptance and availability. If the requested products are out of stock, the service provider will reach out to you via email or phone."
        ),
        Term(
            title: "6. Pricing",
            content: "The prices for goods you order are listed on our website. All prices include VAT at the applicable rates and are accurate at the time of entry."
        )
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 24) {
                        Text("Terms and\nConditions")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.primary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        TermsCardView(termsItems: termsItems)
                    }
                    .padding(.vertical, 12)
                }
                TaskBarView(currentView: "terms")
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        }
    }
}

// MARK: - Terms Content Card

// Displays the terms items in a styled card format
struct TermsCardView: View {
    let termsItems: [Term]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(termsItems.indices, id: \.self) { index in
                TermsItem(title: termsItems[index].title, content: termsItems[index].content)

                if index < termsItems.count - 1 {
                    Divider()
                        .padding(.horizontal, 64)
                }
            }
        }
        .padding()
        .padding(.vertical, 12)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.12), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

// MARK: - Terms Item View Struct

// Displays each term with a title and detailed content
struct TermsItem: View {
    let title: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)

            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    TermsOfServiceView()
}
