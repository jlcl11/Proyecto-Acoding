//
//  MainTabView.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView {
            // Home Tab - Manga List
            Tab("Inicio", systemImage: "house.fill") {
                ContentView()
            }

            // Search Tab
            Tab("Buscar", systemImage: "magnifyingglass", role: .search) {
                SearchView()
            }

            // Profile Tab
            Tab("Perfil", systemImage: "person.fill") {
                ProfileView()
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}

#Preview {
    MainTabView()
}
