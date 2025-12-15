//
//  Manga.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation
import SwiftUI

struct Manga: Identifiable, Hashable, Sendable {
    let id: Int
    let title: String
    let japaneseTitle: String?
    let englishTitle: String?
    let score: Double
    let status: MangaStatus
    let startDate: Date?
    let endDate: Date?
    let totalChapters: Int?
    let totalVolumes: Int?
    let synopsis: String
    let background: String?
    let coverImageURL: URL?
    let externalURL: URL?
    let authors: [Author]
    let genres: [Genre]
    let themes: [Theme]
    let demographics: [Demographic]

    // MARK: - Computed Properties

    var formattedScore: String {
        String(format: "%.2f", score)
    }

    var scorePercentage: Double {
        score * 10 // Convierte de escala 0-10 a 0-100
    }

    var isCompleted: Bool {
        status == .finished
    }

    var isOngoing: Bool {
        status == .publishing
    }

    var primaryGenre: Genre? {
        genres.first
    }

    var primaryDemographic: Demographic? {
        demographics.first
    }

    var authorNames: String {
        authors.map { $0.fullName }.joined(separator: ", ")
    }

    var genreNames: String {
        genres.map { $0.name }.joined(separator: ", ")
    }

    var themeNames: String {
        themes.map { $0.name }.joined(separator: ", ")
    }

    var publicationPeriod: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"

        let start = startDate.map { formatter.string(from: $0) } ?? "?"
        let end = endDate.map { formatter.string(from: $0) } ?? "Actualidad"

        return "\(start) - \(end)"
    }
}

// MARK: - Manga Status Enum

enum MangaStatus: String, Codable, CaseIterable {
    case publishing = "publishing"
    case finished = "finished"
    case hiatus = "hiatus"
    case discontinued = "discontinued"
    case upcoming = "upcoming"
    case unknown = "unknown"

    var displayName: String {
        switch self {
        case .publishing: return "En publicación"
        case .finished: return "Finalizado"
        case .hiatus: return "En pausa"
        case .discontinued: return "Discontinuado"
        case .upcoming: return "Próximamente"
        case .unknown: return "Desconocido"
        }
    }

    var color: Color {
        switch self {
        case .publishing: return .green
        case .finished: return .blue
        case .hiatus: return .orange
        case .discontinued: return .red
        case .upcoming: return .purple
        case .unknown: return .gray
        }
    }
}
