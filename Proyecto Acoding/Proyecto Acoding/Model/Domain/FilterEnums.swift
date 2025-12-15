//
//  FilterEnums.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation

enum GenreFilter: String, CaseIterable, Identifiable {
    case action = "Action"
    case adventure = "Adventure"
    case comedy = "Comedy"
    case drama = "Drama"
    case fantasy = "Fantasy"
    case horror = "Horror"
    case mystery = "Mystery"
    case psychological = "Psychological"
    case romance = "Romance"
    case sciFi = "Sci-Fi"
    case sliceOfLife = "Slice of Life"
    case sports = "Sports"
    case supernatural = "Supernatural"
    case thriller = "Thriller"

    var id: String { rawValue }
}

enum ThemeFilter: String, CaseIterable, Identifiable {
    case school = "School"
    case military = "Military"
    case historical = "Historical"
    case vampire = "Vampire"
    case martialArts = "Martial Arts"
    case superPower = "Super Power"
    case magic = "Magic"
    case mecha = "Mecha"
    case music = "Music"
    case parody = "Parody"
    case space = "Space"
    case delinquents = "Delinquents"
    case samurai = "Samurai"
    case harem = "Harem"

    var id: String { rawValue }
}

enum DemographicFilter: String, CaseIterable, Identifiable {
    case shounen = "Shounen"
    case shoujo = "Shoujo"
    case seinen = "Seinen"
    case josei = "Josei"
    case kids = "Kids"

    var id: String { rawValue }

    var localizedName: String {
        switch self {
        case .shounen: return "Shounen (Chicos jóvenes)"
        case .shoujo: return "Shoujo (Chicas jóvenes)"
        case .seinen: return "Seinen (Adultos)"
        case .josei: return "Josei (Mujeres adultas)"
        case .kids: return "Kids (Niños)"
        }
    }
}
