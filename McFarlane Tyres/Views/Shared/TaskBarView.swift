//
//  TaskBarView.swift
//  McFarlane Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//
//  This displays the taskbar with navigation links for Home, FAQ, Basket and Settings views.
//

import SwiftData
import SwiftUI

//  A task bar icon struct allows better readability of the taskbar icons
struct TaskBarIcon {
    let id: String
    let icon: String
    let filledIcon: String
    let destination: AnyView
    var itemCount: Int? = nil
}

struct TaskBarView: View {
    var currentView: String

    @Environment(\.modelContext) private var context

    @Query private var basketItems: [BasketItem]
    @Query private var users: [User]

    // Check if any user is logged in
    private var currentUser: User? { users.first(where: { $0.loggedIn }) }

    // Get the count of items in the basket for the currently logged-in user
    private var basketItemCount: Int { basketItems.filter { item in item.user?.id == currentUser?.id }.count }

    ///  Initialises the taskbar with the current view
    private func taskBarLink(for item: TaskBarIcon) -> AnyView {
        let imageName = currentView == item.id ? item.filledIcon : item.icon
        let icon = Image(systemName: imageName)
            .font(.system(size: 28))
            .foregroundColor(.primary)

        let view = ZStack {
            icon

            // Show the basket item count if the current item is the basket
            if item.id == "basket" && basketItemCount > 0 {
                Text("\(basketItemCount)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .offset(x: 14, y: -18)
            }
        }

        return currentView == item.id
            ? AnyView(view)
            : AnyView(NavigationLink(destination: item.destination) { view })
    }

    var body: some View {
        let items: [TaskBarIcon] = [
            TaskBarIcon(id: "home", icon: "house", filledIcon: "house.fill", destination: AnyView(HomeView())),
            TaskBarIcon(id: "faq", icon: "info.circle", filledIcon: "info.circle.fill", destination: AnyView(FAQView())),
            TaskBarIcon(id: "basket", icon: "cart", filledIcon: "cart.fill", destination: AnyView(BasketView())),
            TaskBarIcon(id: "account", icon: "person", filledIcon: "person.fill", destination: AnyView(SettingsView())),
        ]

        VStack {
            Divider()
                .background(Color.gray)
                .frame(height: 0)
                .padding(.bottom, 10)

            HStack(spacing: 30) {
                Spacer()
                ForEach(items, id: \.id) { item in
                    taskBarLink(for: item)
                    Spacer()
                }
            }
            .padding(.horizontal)
            .padding(.bottom, -4)
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
    }
}
