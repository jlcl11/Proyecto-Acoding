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

    /// POST request with Basic Authentication
    static func postWithBasicAuth<T: Encodable>(url: URL, body: T, username: String, password: String) throws -> URLRequest {
        var request = try post(url: url, body: body)

        let credentials = "\(username):\(password)"
        if let credentialsData = credentials.data(using: .utf8) {
            let base64Credentials = credentialsData.base64EncodedString()
            request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
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
