//
//  PaginatedResponseDTO.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation

struct PaginatedResponseDTO<T: Codable>: Codable {
    let items: [T]
    let metadata: MetadataDTO

    enum CodingKeys: String, CodingKey {
        case items
        case metadata
    }
}

struct MetadataDTO: Codable {
    let total: Int
    let page: Int
    let per: Int

    enum CodingKeys: String, CodingKey {
        case total
        case page
        case per
    }
}
