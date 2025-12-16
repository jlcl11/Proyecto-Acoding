//
//  AuthViewModel.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 16/12/25.
//

import Foundation

@Observable @MainActor
final class AuthViewModel {

    private let repository: AuthRepositoryProtocol
    private let keychainService: KeychainServiceProtocol

    // MARK: - State

    private(set) var state: AuthState = .checking
    private(set) var error: String?

    // Form Fields
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""

    // MARK: - Computed Properties

    var isAuthenticated: Bool {
        state == .authenticated
    }

    var isValidEmail: Bool {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmail.isEmpty else { return false }
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return trimmedEmail.range(of: emailRegex, options: .regularExpression) != nil
    }

    var isValidPassword: Bool {
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedPassword.count >= 8
    }

    var passwordsMatch: Bool {
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedConfirm = confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedPassword == trimmedConfirm && !trimmedPassword.isEmpty
    }

    var canLogin: Bool {
        isValidEmail && isValidPassword
    }

    var canRegister: Bool {
        isValidEmail && isValidPassword && passwordsMatch
    }

    // MARK: - Enums

    enum AuthState: Equatable {
        case checking
        case unauthenticated
        case authenticating
        case authenticated
        case error(String)
    }

    // MARK: - Init

    init(
        repository: AuthRepositoryProtocol,
        keychainService: KeychainServiceProtocol
    ) {
        self.repository = repository
        self.keychainService = keychainService
    }

    // MARK: - Public Methods

    func checkAuthStatus() async {
        state = .checking

        if await repository.isAuthenticated {
            // Check if token needs renewal (48 hour threshold)
            if await repository.shouldRenewToken {
                do {
                    _ = try await repository.renewToken()
                    state = .authenticated
                } catch {
                    // Token expired or renewal failed, need login
                    state = .unauthenticated
                }
            } else {
                // Token is still fresh, no need to renew
                state = .authenticated
            }
        } else {
            state = .unauthenticated
        }
    }

    func login() async {
        guard canLogin else {
            self.error = "Por favor, completa todos los campos correctamente"
            return
        }

        state = .authenticating
        error = nil

        do {
            // Trim whitespace from email and password
            let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

            let token = try await repository.login(email: trimmedEmail, password: trimmedPassword)
            try await keychainService.save(token: token)
            clearForm()
            state = .authenticated
        } catch let authError as AuthError {
            state = .unauthenticated
            self.error = authError.localizedDescription
        } catch {
            state = .unauthenticated
            self.error = "Ha ocurrido un error inesperado"
        }
    }

    func register() async {
        guard canRegister else {
            self.error = "Por favor, completa todos los campos correctamente"
            return
        }

        state = .authenticating
        error = nil

        do {
            // Trim whitespace from email and password
            let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

            // Update the form fields with trimmed values
            email = trimmedEmail
            password = trimmedPassword

            try await repository.register(email: trimmedEmail, password: trimmedPassword)

            // Small delay to allow server to propagate the new account
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds

            // Auto-login after registration
            await login()
        } catch let authError as AuthError {
            state = .unauthenticated
            self.error = authError.localizedDescription
        } catch is CancellationError {
            // Task was cancelled, ignore
            state = .unauthenticated
        } catch {
            state = .unauthenticated
            self.error = "No se pudo crear la cuenta"
        }
    }

    func logout() async {
        await repository.logout()
        try? await keychainService.deleteToken()
        clearForm()
        state = .unauthenticated
    }

    func clearError() {
        error = nil
    }

    // MARK: - Private

    private func clearForm() {
        email = ""
        password = ""
        confirmPassword = ""
    }
}
