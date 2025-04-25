//
//  McFarlane_TyresApp.swift
//  McFarlane's Tyres
//
//  Created by Daniel McFarlane on 25/04/2025.
//

import SwiftData
import SwiftUI

@main
struct McFarlane_TyresApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
            }
        }
        .modelContainer(for: [
            User.self,
            Tyre.self,
            BasketItem.self,
            Order.self,
            OrderLine.self,
        ])
    }
}
