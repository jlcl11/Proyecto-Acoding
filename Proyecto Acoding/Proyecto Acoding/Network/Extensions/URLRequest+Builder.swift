//
//  URLRequest+Builder.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation

extension URLRequest {

    // MARK: - Basic Request Builders

    static func get(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }

    static func post<T: Encodable>(url: URL, body: T) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try JSONEncoder().encode(body)
        return request
    }

    static func delete(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        return request
    }

    // MARK: - Authentication Request Builders

    /// POST request with App-Token header for registration
    /// The App-Token is required by the API to identify the app (PDF spec page 4)
    static func postWithAppToken<T: Encodable>(url: URL, body: T) throws -> URLRequest {
        var request = try post(url: url, body: body)
        request.setValue(APIConstants.appToken, forHTTPHeaderField: "App-Token")
        return request
    }

    /// POST request with Basic Authentication (credentials in Authorization header only)
    static func postWithBasicAuth(url: URL, username: String, password: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // Encode credentials as Base64 for Basic Auth
        let credentials = "\(username):\(password)"
        if let credentialsData = credentials.data(using: .utf8) {
            let base64Credentials = credentialsData.base64EncodedString()
            let authHeader = "Basic \(base64Credentials)"
            request.setValue(authHeader, forHTTPHeaderField: "Authorization")

            // Debug logging
            print("🔐 Basic Auth - Username: '\(username)'")
            print("🔐 Basic Auth - Password length: \(password.count) chars")
            print("🔐 Basic Auth - Credentials string: '\(credentials)...'")
            print("🔐 Basic Auth - Base64: \(base64Credentials)...")
            print("🔐 Basic Auth - Header: \(authHeader.prefix(40))...")
        }

        return request
    }

    /// POST request with Bearer Token
    static func postWithBearerToken<T: Encodable>(url: URL, body: T, token: String) throws -> URLRequest {
        var request = try post(url: url, body: body)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
