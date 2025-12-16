//
//  AuthRepository.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 16/12/25.
//

import Foundation

class AuthRepository: AuthRepositoryProtocol {

    private let apiClient: APIClient
    private let tokenManager: TokenManagerProtocol

    init(
        apiClient: APIClient = APIClient(),
        tokenManager: TokenManagerProtocol
    ) {
        self.apiClient = apiClient
        self.tokenManager = tokenManager
    }

    // MARK: - AuthRepositoryProtocol

    func register(email: String, password: String) async throws {
        do {
            try await apiClient.register(email: email, password: password)
        } catch let networkError as NetworkError {
            // Preserve network error information
            throw AuthError.networkError(networkError.localizedDescription)
        } catch {
            throw AuthError.registrationFailed
        }
    }

    func login(email: String, password: String) async throws -> String {
        do {
            let token = try await apiClient.login(email: email, password: password)
            await tokenManager.updateToken(token)
            return token
        } catch let networkError as NetworkError {
            // Preserve network error information
            switch networkError {
            case .unauthorized:
                throw AuthError.invalidCredentials
            default:
                throw AuthError.networkError(networkError.localizedDescription)
            }
        } catch {
            throw AuthError.invalidCredentials
        }
    }

    func renewToken() async throws -> String {
        guard let currentToken = await tokenManager.currentToken else {
            throw AuthError.notAuthenticated
        }

        do {
            let newToken = try await apiClient.renewToken(currentToken)
            await tokenManager.updateToken(newToken)
            return newToken
        } catch {
            throw AuthError.tokenExpired
        }
    }

    func logout() async {
        await tokenManager.clearToken()
    }

    var isAuthenticated: Bool {
        get async {
            await tokenManager.currentToken != nil
        }
    }

    var currentToken: String? {
        get async {
            await tokenManager.currentToken
        }
    }

    var shouldRenewToken: Bool {
        get async {
            await tokenManager.shouldRenewToken
        }
    }
}
