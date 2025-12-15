//
//  UserMangaCollectionDTO.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation

struct UserMangaCollectionRequestDTO: Codable {
    let manga: Int
    let completeCollection: Bool
    let volumesOwned: [Int]
    let readingVolume: Int?
}

struct UserMangaCollectionResponseDTO: Codable {
    let manga: MangaDTO
    let completeCollection: Bool
    let volumesOwned: [Int]
    let readingVolume: Int?
}
