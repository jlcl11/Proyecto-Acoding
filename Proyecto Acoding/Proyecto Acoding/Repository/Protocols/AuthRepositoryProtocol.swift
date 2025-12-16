//
//  AuthRepositoryProtocol.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 16/12/25.
//

import Foundation

protocol AuthRepositoryProtocol: Sendable {
    func register(email: String, password: String) async throws
    func login(email: String, password: String) async throws -> String
    func renewToken() async throws -> String
    func logout() async
    var isAuthenticated: Bool { get async }
    var currentToken: String? { get async }
    var shouldRenewToken: Bool { get async }
}

enum AuthError: LocalizedError {
    case notAuthenticated
    case invalidCredentials
    case registrationFailed
    case tokenExpired
    case emailInvalid
    case passwordTooShort
    case networkError(String)

    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "No has iniciado sesión"
        case .invalidCredentials:
            return "Email o contraseña incorrectos"
        case .registrationFailed:
            return "No se pudo crear la cuenta"
        case .tokenExpired:
            return "Tu sesión ha expirado"
        case .emailInvalid:
            return "El email no tiene un formato válido"
        case .passwordTooShort:
            return "La contraseña debe tener al menos 8 caracteres"
        case .networkError(let message):
            return message
        }
    }
}
