//
//  CustomSearchDTO.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation

struct CustomSearchDTO: Codable {
    var searchTitle: String?
    var searchAuthorFirstName: String?
    var searchAuthorLastName: String?
    var searchGenres: [String]?
    var searchThemes: [String]?
    var searchDemographics: [String]?
    var searchContains: Bool

    init(
        title: String? = nil,
        authorFirstName: String? = nil,
        authorLastName: String? = nil,
        genres: [String]? = nil,
        themes: [String]? = nil,
        demographics: [String]? = nil,
        containsSearch: Bool = false
    ) {
        self.searchTitle = title
        self.searchAuthorFirstName = authorFirstName
        self.searchAuthorLastName = authorLastName
        self.searchGenres = genres
        self.searchThemes = themes
        self.searchDemographics = demographics
        self.searchContains = containsSearch
    }
}
