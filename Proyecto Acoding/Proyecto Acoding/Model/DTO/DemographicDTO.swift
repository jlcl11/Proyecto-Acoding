//
//  DemographicDTO.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation

struct DemographicDTO: Codable, Hashable {
    let id: String
    let demographic: String

    enum CodingKeys: String, CodingKey {
        case id
        case demographic
    }
}
