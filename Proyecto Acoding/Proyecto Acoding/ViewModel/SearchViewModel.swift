//
//  SearchViewModel.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation
import Observation

@Observable @MainActor
final class SearchViewModel {

    // MARK: - Dependencies

    private let repository: MangaRepositoryProtocol

    // MARK: - State

    private(set) var searchResults: [Manga] = []
    private(set) var state: ViewState = .idle
    private(set) var metadata: PaginationMetadata?

    var currentPage: Int = 1
    var itemsPerPage: Int = 20

    // MARK: - Computed Properties

    var hasMorePages: Bool {
        metadata?.hasNextPage ?? false
    }

    var isEmpty: Bool {
        searchResults.isEmpty && state == .loaded
    }

    // MARK: - Init

    init(repository: MangaRepositoryProtocol) {
        self.repository = repository
    }

    // Convenience init for production
    convenience init() {
        self.init(repository: MangaRepository())
    }

    // MARK: - Search Methods

    // Store the last search DTO for pagination
    private var lastSearchDTO: CustomSearchDTO?

    func search(query: String) async {
        guard !query.isEmpty else {
            reset()
            return
        }

        let searchDTO = CustomSearchDTO(
            title: query,
            containsSearch: true
        )

        await searchWithDTO(searchDTO)
    }

    func searchWithDTO(_ searchDTO: CustomSearchDTO) async {
        guard state != .loading else { return }

        print("🔍 SearchViewModel: Searching with filters")
        state = .loading
        currentPage = 1
        lastSearchDTO = searchDTO

        do {
            let response = try await repository.searchMangas(
                query: searchDTO,
                page: currentPage,
                per: itemsPerPage
            )

            print("🎉 SearchViewModel: Found \(response.items.count) results")

            searchResults = response.items
            metadata = response.metadata
            state = searchResults.isEmpty ? .empty : .loaded

            print("✅ SearchViewModel: Search completed")

        } catch {
            print("❌ SearchViewModel: Search error - \(error)")
            state = .error(error.localizedDescription)
        }
    }

    func loadNextPage(query: String) async {
        guard let lastSearchDTO else {
            // Fallback to simple query search
            await loadNextPageWithQuery(query)
            return
        }

        await loadNextPageWithDTO(lastSearchDTO)
    }

    private func loadNextPageWithQuery(_ query: String) async {
        guard hasMorePages, state != .loading, !query.isEmpty else { return }

        print("📄 SearchViewModel: Loading next page")
        currentPage += 1

        do {
            let searchDTO = CustomSearchDTO(
                title: query,
                containsSearch: true
            )

            let response = try await repository.searchMangas(
                query: searchDTO,
                page: currentPage,
                per: itemsPerPage
            )

            searchResults.append(contentsOf: response.items)
            metadata = response.metadata

        } catch {
            print("❌ SearchViewModel: Error loading next page - \(error)")
            currentPage -= 1 // Revert on error
        }
    }

    private func loadNextPageWithDTO(_ searchDTO: CustomSearchDTO) async {
        guard hasMorePages, state != .loading else { return }

        print("📄 SearchViewModel: Loading next page with filters")
        currentPage += 1

        do {
            let response = try await repository.searchMangas(
                query: searchDTO,
                page: currentPage,
                per: itemsPerPage
            )

            searchResults.append(contentsOf: response.items)
            metadata = response.metadata

        } catch {
            print("❌ SearchViewModel: Error loading next page - \(error)")
            currentPage -= 1
        }
    }

    func reset() {
        searchResults = []
        metadata = nil
        currentPage = 1
        state = .idle
        print("🔄 SearchViewModel: Reset")
    }
}
