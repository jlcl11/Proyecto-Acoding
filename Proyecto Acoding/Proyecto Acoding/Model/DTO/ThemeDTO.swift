//
//  ThemeDTO.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation

struct ThemeDTO: Codable, Hashable {
    let id: String
    let theme: String

    enum CodingKeys: String, CodingKey {
        case id
        case theme
    }
}
