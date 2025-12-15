//
//  ProfileView.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import SwiftUI

struct ProfileView: View {
    @State private var userName = "Usuario"
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            List {
                // Profile Header
                Section {
                    HStack(spacing: 16) {
                        // Profile Image Placeholder
                        Circle()
                            .fill(Color.accentColor.opacity(0.2))
                            .frame(width: 70, height: 70)
                            .overlay {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 30))
                                    .foregroundStyle(.primary)
                            }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(userName)
                                .font(.title2)
                                .fontWeight(.bold)

                            Text("Ver perfil")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()
                    }
                    .padding(.vertical, 8)
                }

                // Statistics
                Section("Estadísticas") {
                    HStack {
                        StatItem(title: "Leyendo", value: "0")
                        Divider()
                        StatItem(title: "Completados", value: "0")
                        Divider()
                        StatItem(title: "En lista", value: "0")
                    }
                    .frame(height: 60)
                }

                // My Lists
                Section("Mi Biblioteca") {
                    NavigationLink {
                        Text("Leyendo ahora")
                    } label: {
                        Label("Leyendo ahora", systemImage: "book.fill")
                    }

                    NavigationLink {
                        Text("Completados")
                    } label: {
                        Label("Completados", systemImage: "checkmark.circle.fill")
                    }

                    NavigationLink {
                        Text("Mi lista")
                    } label: {
                        Label("Mi lista", systemImage: "bookmark.fill")
                    }

                    NavigationLink {
                        Text("Favoritos")
                    } label: {
                        Label("Favoritos", systemImage: "heart.fill")
                    }
                }

                // Settings
                Section("Configuración") {
                    NavigationLink {
                        Text("Notificaciones")
                    } label: {
                        Label("Notificaciones", systemImage: "bell.fill")
                    }

                    NavigationLink {
                        Text("Preferencias")
                    } label: {
                        Label("Preferencias", systemImage: "gear")
                    }

                    NavigationLink {
                        Text("Apariencia")
                    } label: {
                        Label("Apariencia", systemImage: "paintbrush.fill")
                    }
                }

                // About
                Section("Acerca de") {
                    NavigationLink {
                        Text("Ayuda")
                    } label: {
                        Label("Ayuda", systemImage: "questionmark.circle.fill")
                    }

                    NavigationLink {
                        Text("Acerca de")
                    } label: {
                        Label("Acerca de", systemImage: "info.circle.fill")
                    }
                }

                // Logout
                Section {
                    Button(role: .destructive) {
                        // Logout action
                    } label: {
                        HStack {
                            Spacer()
                            Label("Cerrar sesión", systemImage: "rectangle.portrait.and.arrow.right")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Perfil")
        }
    }
}

// MARK: - Supporting Views

struct StatItem: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ProfileView()
}
