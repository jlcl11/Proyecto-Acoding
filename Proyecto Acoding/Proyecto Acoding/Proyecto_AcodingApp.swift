//
//  Proyecto_AcodingApp.swift
//  Proyecto Acoding
//
//  Created by José Luis Corral López on 15/12/25.
//

import SwiftUI

@main
struct Proyecto_AcodingApp: App {

    // MARK: - Dependency Injection

    @State private var authViewModel: AuthViewModel

    init() {
        // Setup authentication dependencies
        let keychainService = KeychainService()
        let tokenManager = TokenManager(keychainService: keychainService)
        let authRepository = AuthRepository(tokenManager: tokenManager)

        _authViewModel = State(initialValue: AuthViewModel(
            repository: authRepository,
            keychainService: keychainService
        ))
    }

    var body: some Scene {
        WindowGroup {
            Group {
                switch authViewModel.state {
                case .checking:
                    // Show splash screen while checking auth
                    VStack(spacing: 20) {
                        Image(systemName: "book.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .foregroundStyle(.blue)
                        Text("Mis Mangas")
                            .font(.largeTitle.bold())
                        ProgressView()
                    }
                    .environment(\.colorScheme, .light)

                case .unauthenticated, .authenticating, .error:
                    // Show login view with sheet for register
                    LoginView()
                        .environment(authViewModel)
                        .environment(\.colorScheme, .light)

                case .authenticated:
                    // Show main app
                    MainTabView()
                        .environment(authViewModel)
                        .environment(\.colorScheme, .light)
                }
            }
            .task {
                // Check authentication status on launch
                await authViewModel.checkAuthStatus()
            }
        }
    }
}
