//
//  KeychainService.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 16/12/25.
//

import Foundation
import Security

protocol KeychainServiceProtocol: Sendable {
    func save(token: String) async throws
    func getToken() async throws -> String?
    func deleteToken() async throws
}

actor KeychainService: KeychainServiceProtocol {

    private let tokenKey = "com.proyectoacoding.authToken"
    private let service = "ProyectoAcodingApp"

    // MARK: - Token Management

    func save(token: String) async throws {
        // Delete existing token first
        try deleteItem(key: tokenKey)

        guard let data = token.data(using: .utf8) else {
            throw KeychainError.encodingFailed
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: tokenKey,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else {
            throw KeychainError.saveFailed(status)
        }
    }

    func getToken() async throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: tokenKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let data = result as? Data,
              let token = String(data: data, encoding: .utf8) else {
            if status == errSecItemNotFound {
                return nil
            }
            throw KeychainError.readFailed(status)
        }

        return token
    }

    func deleteToken() async throws {
        try deleteItem(key: tokenKey)
    }

    // MARK: - Private Helpers

    private func deleteItem(key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.deleteFailed(status)
        }
    }
}

enum KeychainError: LocalizedError {
    case encodingFailed
    case saveFailed(OSStatus)
    case readFailed(OSStatus)
    case deleteFailed(OSStatus)

    var errorDescription: String? {
        switch self {
        case .encodingFailed:
            return "Error al codificar datos"
        case .saveFailed(let status):
            return "Error al guardar en Keychain (\(status))"
        case .readFailed(let status):
            return "Error al leer de Keychain (\(status))"
        case .deleteFailed(let status):
            return "Error al eliminar de Keychain (\(status))"
        }
    }
}
