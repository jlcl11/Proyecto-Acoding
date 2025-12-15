//
//  SearchFiltersViewModel.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation
import Observation

@Observable @MainActor
final class SearchFiltersViewModel {

    // MARK: - Available Options (from Enums)

    let availableGenres: [GenreFilter] = GenreFilter.allCases
    let availableThemes: [ThemeFilter] = ThemeFilter.allCases
    let availableDemographics: [DemographicFilter] = DemographicFilter.allCases

    // MARK: - Selected Filters

    var searchTitle: String = ""
    var searchAuthorFirstName: String = ""
    var searchAuthorLastName: String = ""
    var selectedGenres: Set<GenreFilter> = []
    var selectedThemes: Set<ThemeFilter> = []
    var selectedDemographics: Set<DemographicFilter> = []
    var containsSearch: Bool = true

    // MARK: - Computed Properties

    var hasActiveFilters: Bool {
        !searchTitle.isEmpty ||
        !searchAuthorFirstName.isEmpty ||
        !searchAuthorLastName.isEmpty ||
        !selectedGenres.isEmpty ||
        !selectedThemes.isEmpty ||
        !selectedDemographics.isEmpty
    }

    var activeFiltersCount: Int {
        var count = 0
        if !searchTitle.isEmpty { count += 1 }
        if !searchAuthorFirstName.isEmpty { count += 1 }
        if !searchAuthorLastName.isEmpty { count += 1 }
        count += selectedGenres.count
        count += selectedThemes.count
        count += selectedDemographics.count
        return count
    }

    // MARK: - Init

    init() {
        // No initialization needed - using enums
    }

    // MARK: - Create Search DTO

    func createSearchDTO() -> CustomSearchDTO {
        return CustomSearchDTO(
            title: searchTitle.isEmpty ? nil : searchTitle,
            authorFirstName: searchAuthorFirstName.isEmpty ? nil : searchAuthorFirstName,
            authorLastName: searchAuthorLastName.isEmpty ? nil : searchAuthorLastName,
            genres: selectedGenres.isEmpty ? nil : selectedGenres.map { $0.rawValue },
            themes: selectedThemes.isEmpty ? nil : selectedThemes.map { $0.rawValue },
            demographics: selectedDemographics.isEmpty ? nil : selectedDemographics.map { $0.rawValue },
            containsSearch: containsSearch
        )
    }

    // MARK: - Reset Filters

    func resetAllFilters() {
        searchTitle = ""
        searchAuthorFirstName = ""
        searchAuthorLastName = ""
        selectedGenres.removeAll()
        selectedThemes.removeAll()
        selectedDemographics.removeAll()
        containsSearch = true
        print("🔄 SearchFiltersViewModel: All filters reset")
    }

    func clearTextFilters() {
        searchTitle = ""
        searchAuthorFirstName = ""
        searchAuthorLastName = ""
    }

    func clearCategoryFilters() {
        selectedGenres.removeAll()
        selectedThemes.removeAll()
        selectedDemographics.removeAll()
    }
}
