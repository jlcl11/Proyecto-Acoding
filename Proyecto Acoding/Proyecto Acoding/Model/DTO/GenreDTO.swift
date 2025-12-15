//
//  GenreDTO.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation

struct GenreDTO: Codable, Hashable {
    let id: String
    let genre: String

    enum CodingKeys: String, CodingKey {
        case id
        case genre
    }
}
