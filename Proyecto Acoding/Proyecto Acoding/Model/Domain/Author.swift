//
//  Author.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation

struct Author: Identifiable, Hashable, Sendable {
    let id: String
    let firstName: String
    let lastName: String
    let role: AuthorRole

    var fullName: String {
        "\(firstName) \(lastName)"
    }

    var displayNameWithRole: String {
        "\(fullName) (\(role.displayName))"
    }
}

enum AuthorRole: String, Codable, CaseIterable {
    case storyAndArt = "Story & Art"
    case story = "Story"
    case art = "Art"
    case unknown = "Unknown"

    var displayName: String {
        switch self {
        case .storyAndArt: return "Historia y Arte"
        case .story: return "Historia"
        case .art: return "Arte"
        case .unknown: return "Desconocido"
        }
    }

    var icon: String {
        switch self {
        case .storyAndArt: return "person.2.fill"
        case .story: return "pencil"
        case .art: return "paintbrush.fill"
        case .unknown: return "questionmark"
        }
    }
}
