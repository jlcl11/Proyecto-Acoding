//
//  MangaRepository.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation

// Simplified - no Actor, just class
class MangaRepository: MangaRepositoryProtocol {

    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
        print("🏗️ MangaRepository: Initialized")
    }

    // MARK: - List

    func getMangas(page: Int, per: Int) async throws -> PaginatedResponse<Manga> {
        print("📚 MangaRepository: Getting mangas (page: \(page), per: \(per))")
        let result = try await apiClient.getMangas(page: page, per: per)
        print("✅ MangaRepository: Got \(result.items.count) mangas")
        return result
    }

    func getBestMangas(page: Int, per: Int) async throws -> PaginatedResponse<Manga> {
        print("📚 MangaRepository: Getting best mangas")
        return try await apiClient.getBestMangas(page: page, per: per)
    }

    func getManga(id: Int) async throws -> Manga {
        print("📚 MangaRepository: Getting manga with id \(id)")
        return try await apiClient.getManga(id: id)
    }

    // MARK: - Search

    func searchMangas(query: CustomSearchDTO, page: Int, per: Int) async throws -> PaginatedResponse<Manga> {
        print("📚 MangaRepository: Searching mangas")
        return try await apiClient.searchMangas(query: query, page: page, per: per)
    }

    // MARK: - Filters

    func getGenres() async throws -> [String] {
        print("📚 MangaRepository: Getting genres")
        return try await apiClient.getGenres()
    }

    func getThemes() async throws -> [String] {
        print("📚 MangaRepository: Getting themes")
        return try await apiClient.getThemes()
    }

    func getDemographics() async throws -> [String] {
        print("📚 MangaRepository: Getting demographics")
        return try await apiClient.getDemographics()
    }

    func getAuthors() async throws -> [Author] {
        print("📚 MangaRepository: Getting authors")
        let dtos = try await apiClient.getAuthors()
        // Map DTOs to Domain models
        return dtos.map { dto in
            Author(
                id: dto.id,
                firstName: dto.firstName,
                lastName: dto.lastName,
                role: AuthorRole(rawValue: dto.role) ?? .unknown
            )
        }
    }

    // MARK: - Filter by Category

    func getMangasByGenre(_ genre: String, page: Int, per: Int) async throws -> PaginatedResponse<Manga> {
        print("📚 MangaRepository: Getting mangas by genre '\(genre)'")
        return try await apiClient.getMangasByGenre(genre, page: page, per: per)
    }

    func getMangasByTheme(_ theme: String, page: Int, per: Int) async throws -> PaginatedResponse<Manga> {
        print("📚 MangaRepository: Getting mangas by theme '\(theme)'")
        return try await apiClient.getMangasByTheme(theme, page: page, per: per)
    }

    func getMangasByDemographic(_ demographic: String, page: Int, per: Int) async throws -> PaginatedResponse<Manga> {
        print("📚 MangaRepository: Getting mangas by demographic '\(demographic)'")
        return try await apiClient.getMangasByDemographic(demographic, page: page, per: per)
    }

    func getMangasByAuthor(_ authorId: String, page: Int, per: Int) async throws -> PaginatedResponse<Manga> {
        print("📚 MangaRepository: Getting mangas by author '\(authorId)'")
        return try await apiClient.getMangasByAuthor(authorId, page: page, per: per)
    }
}
