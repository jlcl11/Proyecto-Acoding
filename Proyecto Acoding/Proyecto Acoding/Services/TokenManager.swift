//
//  TokenManager.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 16/12/25.
//

import Foundation

protocol TokenManagerProtocol: Sendable {
    var currentToken: String? { get async }
    var shouldRenewToken: Bool { get async }
    func updateToken(_ token: String) async
    func clearToken() async
}

actor TokenManager: TokenManagerProtocol {

    private let keychainService: KeychainServiceProtocol
    private var cachedToken: String?
    private var lastRenewalDate: Date?

    init(keychainService: KeychainServiceProtocol) {
        self.keychainService = keychainService
    }

    var currentToken: String? {
        get async {
            // Return cached token if available
            if let cached = cachedToken {
                return cached
            }

            // Load from Keychain if not in cache
            cachedToken = try? await keychainService.getToken()
            return cachedToken
        }
    }

    var shouldRenewToken: Bool {
        get async {
            guard let lastRenewal = lastRenewalDate else {
                return true
            }

            // Renew if older than 48 hours
            return Date().timeIntervalSince(lastRenewal) > 172800
        }
    }

    func updateToken(_ token: String) async {
        cachedToken = token
        lastRenewalDate = Date()
        try? await keychainService.save(token: token)
    }

    func clearToken() async {
        cachedToken = nil
        lastRenewalDate = nil
        try? await keychainService.deleteToken()
    }
}
