//
//  MangasViewModel.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation
import Observation

enum ViewState: Equatable {
    case idle
    case loading
    case loaded
    case error(String)
    case empty

    var isLoading: Bool {
        self == .loading
    }

    var isError: Bool {
        if case .error = self { return true }
        return false
    }

    var errorMessage: String? {
        if case .error(let message) = self {
            return message
        }
        return nil
    }
}

@Observable @MainActor
final class MangasViewModel {

    // MARK: - Dependencies

    private let repository: MangaRepositoryProtocol

    // MARK: - State

    private(set) var mangas: [Manga] = []
    private(set) var state: ViewState = .idle
    private(set) var metadata: PaginationMetadata?

    var currentPage: Int = 1
    var itemsPerPage: Int = 20

    // MARK: - Computed Properties

    var hasMorePages: Bool {
        metadata?.hasNextPage ?? false
    }

    var totalMangas: Int {
        metadata?.total ?? 0
    }

    var displayInfo: String {
        metadata?.displayRange ?? ""
    }

    // MARK: - Init

    init(repository: MangaRepositoryProtocol) {
        self.repository = repository
    }

    // Convenience init para producción
    convenience init() {
        self.init(repository: MangaRepository())
    }

    // MARK: - Public Methods

    func loadMangas() async {
        guard state != .loading else { return }

        print("🎬 MangasViewModel: Starting to load mangas")
        state = .loading

        do {
            let response = try await repository.getMangas(
                page: currentPage,
                per: itemsPerPage
            )

            print("🎉 MangasViewModel: Successfully loaded \(response.items.count) mangas")
            print("📊 MangasViewModel: Total mangas available: \(response.metadata.total)")
            print("📄 MangasViewModel: Current page: \(response.metadata.currentPage)")

            mangas = response.items
            metadata = response.metadata
            state = mangas.isEmpty ? .empty : .loaded

            print("✅ MangasViewModel: State updated to \(state)")

        } catch {
            print("❌ MangasViewModel: Error loading mangas - \(error)")
            state = .error(error.localizedDescription)
        }
    }

    func loadNextPage() async {
        guard hasMorePages, state != .loading else { return }

        currentPage += 1

        do {
            let response = try await repository.getMangas(
                page: currentPage,
                per: itemsPerPage
            )

            mangas.append(contentsOf: response.items)
            metadata = response.metadata

        } catch {
            currentPage -= 1 // Revertir en caso de error
        }
    }

    func refresh() async {
        currentPage = 1
        mangas = []
        metadata = nil
        await loadMangas()
    }
}
