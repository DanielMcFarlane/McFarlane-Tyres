//
//  FAQView.swift
//  McFarlane's Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This view displays frequently asked questions about tyre services.
//

import SwiftUI


//  A FAQ struct allows better readability of the FAQ's
struct FAQ {
    let question: String
    let answer: String
}

struct FAQView: View {
    @Environment(\.colorScheme) var colorScheme // Detect if light or dark mode is being used

    private let faqItems = [
        FAQ(question: "What types of tyres are available?", answer: "We stock a wide range of tyres, including options for various vehicle types, from budget-friendly to premium brands."),
        FAQ(question: "How long does it take to fit new tyres?", answer: "The tyre fitting process usually takes between 30 and 45 minutes, depending on the vehicle and tyre specifications."),
        FAQ(question: "Can you repair a damaged tyre?", answer: "Yes, we offer repair services for minor tyre damages, such as punctures, to restore safety and functionality."),
        FAQ(question: "Do you provide wheel balancing services?", answer: "Yes, we offer wheel balancing to ensure a smoother ride and even tyre wear."),
        FAQ(question: "Is delivery or pickup available?", answer: "Currently, we do not provide delivery or pickup services. However, you are welcome to visit our location to access all available services."),
        FAQ(question: "What are your working hours?", answer: "Our operating hours are as follows:\nMonday to Friday: 08:30 - 17:30\nSaturday: 09:00 - 14:00\nSunday: Closed"),
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 24) {
                        Text("Frequently Asked \nQuestions")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.primary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        // FAQ Content card
                        FAQCardView(faqItems: faqItems)
                    }
                    .padding(.vertical, 12)
                }
                TaskBarView(currentView: "faq")
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}

// MARK: - FAQ Content Card

//  Displays the FAQ items in a card format
struct FAQCardView: View {
    let faqItems: [FAQ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(faqItems.indices, id: \.self) { index in
                FAQItem(question: faqItems[index].question, answer: faqItems[index].answer)

                if index < faqItems.count - 1 {
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

// MARK: - FAQ Item View Struct

//  Displays each FAQ item with question and answer
struct FAQItem: View {
    let question: String
    let answer: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(question)
                .font(.headline)
                .foregroundColor(.primary)

            Text(answer)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    FAQView()
}
