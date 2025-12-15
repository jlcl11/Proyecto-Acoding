//
//  Demographic.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation

struct Demographic: Identifiable, Hashable, Sendable {
    let id: String
    let name: String

    var localizedName: String {
        switch name.lowercased() {
        case "shounen": return "Shounen (Chicos jóvenes)"
        case "shoujo": return "Shoujo (Chicas jóvenes)"
        case "seinen": return "Seinen (Adultos)"
        case "josei": return "Josei (Mujeres adultas)"
        case "kids": return "Kids (Niños)"
        default: return name
        }
    }
}
