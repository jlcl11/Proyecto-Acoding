//
//  MangaDTO.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation

struct MangaDTO: Codable {
    let id: Int
    let title: String
    let titleJapanese: String?
    let titleEnglish: String?
    let score: Double?
    let status: String?
    let startDate: String?
    let endDate: String?
    let chapters: Int?
    let volumes: Int?
    let sypnosis: String?
    let background: String?
    let mainPicture: String?
    let url: String?
    let authors: [AuthorDTO]
    let genres: [GenreDTO]
    let themes: [ThemeDTO]
    let demographics: [DemographicDTO]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case titleJapanese
        case titleEnglish
        case score
        case status
        case startDate
        case endDate
        case chapters
        case volumes
        case sypnosis
        case background
        case mainPicture
        case url
        case authors
        case genres
        case themes
        case demographics
    }
}
