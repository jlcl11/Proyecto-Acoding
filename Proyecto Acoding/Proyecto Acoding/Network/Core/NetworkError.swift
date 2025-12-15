//
//  NetworkError.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case requestFailed(statusCode: Int)
    case decodingFailed(Error)
    case noData
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case noConnection
    case timeout
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .requestFailed(let statusCode):
            return "Error en la petición (código: \(statusCode))"
        case .decodingFailed:
            return "Error al procesar la respuesta"
        case .noData:
            return "No se recibieron datos"
        case .unauthorized:
            return "No autorizado. Inicia sesión nuevamente"
        case .forbidden:
            return "Acceso denegado"
        case .notFound:
            return "Recurso no encontrado"
        case .serverError:
            return "Error del servidor"
        case .noConnection:
            return "Sin conexión a internet"
        case .timeout:
            return "Tiempo de espera agotado"
        case .unknown:
            return "Error desconocido"
        }
    }
}
