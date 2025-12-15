//
//  NetworkInteractor.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation

// Simplified - no Actor, just class with async methods
class NetworkInteractor {

    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
    }

    func execute<T: Decodable>(_ request: URLRequest) async throws -> T {
        print("🌐 NetworkInteractor: Executing request to \(request.url?.absoluteString ?? "unknown")")

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown(NSError(domain: "Invalid response", code: -1))
            }

            print("📡 NetworkInteractor: Got response with status code \(httpResponse.statusCode)")

            try validateResponse(httpResponse)

            do {
                let decoded = try decoder.decode(T.self, from: data)
                print("✅ NetworkInteractor: Successfully decoded response")
                return decoded
            } catch {
                print("❌ NetworkInteractor: Decoding failed - \(error)")
                // Print raw JSON for debugging
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📄 Raw JSON: \(jsonString.prefix(500))...")
                }
                throw NetworkError.decodingFailed(error)
            }

        } catch let error as NetworkError {
            print("❌ NetworkInteractor: Network error - \(error)")
            throw error
        } catch let error as URLError {
            print("❌ NetworkInteractor: URL error - \(error)")
            throw mapURLError(error)
        } catch {
            print("❌ NetworkInteractor: Unknown error - \(error)")
            throw NetworkError.unknown(error)
        }
    }

    // MARK: - Private Helpers

    private func validateResponse(_ response: HTTPURLResponse) throws {
        switch response.statusCode {
        case 200...299:
            return // Success
        case 401:
            throw NetworkError.unauthorized
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        case 500...599:
            throw NetworkError.serverError
        default:
            throw NetworkError.requestFailed(statusCode: response.statusCode)
        }
    }

    private func mapURLError(_ error: URLError) -> NetworkError {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost:
            return .noConnection
        case .timedOut:
            return .timeout
        default:
            return .unknown(error)
        }
    }
}
