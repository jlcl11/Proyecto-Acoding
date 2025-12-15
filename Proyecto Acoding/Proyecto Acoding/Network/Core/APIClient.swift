//
//  APIClient.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation

// Simplified - no Actor, just class
class APIClient {

    private let network: NetworkInteractor
    private let mangaMapper: MangaMapper

    init(network: NetworkInteractor = NetworkInteractor()) {
        self.network = network
        self.mangaMapper = MangaMapper()
        print("🏗️ APIClient: Initialized")
    }

    // MARK: - Mangas

    func getMangas(page: Int, per: Int) async throws -> PaginatedResponse<Manga> {
        print("📱 APIClient: Getting mangas (page: \(page), per: \(per))")

        let url = URL.mangaList.withPagination(page: page, per: per)
        let request = URLRequest.get(url: url)

        let response: PaginatedResponseDTO<MangaDTO> = try await network.execute(request)

        print("📦 APIClient: Got \(response.items.count) mangas")

        let mapped = mangaMapper.mapPaginated(response)
        print("✅ APIClient: Mapped to domain models")

        return mapped
    }

    func getBestMangas(page: Int, per: Int) async throws -> PaginatedResponse<Manga> {
        print("📱 APIClient: Getting best mangas (page: \(page), per: \(per))")

        let url = URL.bestMangas.withPagination(page: page, per: per)
        let request = URLRequest.get(url: url)

        let response: PaginatedResponseDTO<MangaDTO> = try await network.execute(request)
        return mangaMapper.mapPaginated(response)
    }

    func getManga(id: Int) async throws -> Manga {
        print("📱 APIClient: Getting manga with id \(id)")

        let url = URL.manga(id: id)
        let request = URLRequest.get(url: url)

        let dto: MangaDTO = try await network.execute(request)
        return mangaMapper.map(dto)
    }

    func searchMangas(query: CustomSearchDTO, page: Int, per: Int) async throws -> PaginatedResponse<Manga> {
        print("📱 APIClient: Searching mangas")

        let url = URL.customSearch.withPagination(page: page, per: per)
        let request = try URLRequest.post(url: url, body: query)

        let response: PaginatedResponseDTO<MangaDTO> = try await network.execute(request)
        return mangaMapper.mapPaginated(response)
    }

    // MARK: - Filters

    func getGenres() async throws -> [String] {
        print("📱 APIClient: Getting genres")
        let request = URLRequest.get(url: .genres)
        return try await network.execute(request)
    }

    func getThemes() async throws -> [String] {
        print("📱 APIClient: Getting themes")
        let request = URLRequest.get(url: .themes)
        return try await network.execute(request)
    }

    func getDemographics() async throws -> [String] {
        print("📱 APIClient: Getting demographics")
        let request = URLRequest.get(url: .demographics)
        return try await network.execute(request)
    }

    func getAuthors() async throws -> [AuthorDTO] {
        print("📱 APIClient: Getting authors")
        let request = URLRequest.get(url: .authors)
        return try await network.execute(request)
    }

    // MARK: - Filter by Category

    func getMangasByGenre(_ genre: String, page: Int, per: Int) async throws -> PaginatedResponse<Manga> {
        print("📱 APIClient: Getting mangas by genre '\(genre)'")

        let url = URL.mangaByGenre(genre).withPagination(page: page, per: per)
        let request = URLRequest.get(url: url)

        let response: PaginatedResponseDTO<MangaDTO> = try await network.execute(request)
        return mangaMapper.mapPaginated(response)
    }

    func getMangasByTheme(_ theme: String, page: Int, per: Int) async throws -> PaginatedResponse<Manga> {
        print("📱 APIClient: Getting mangas by theme '\(theme)'")

        let url = URL.mangaByTheme(theme).withPagination(page: page, per: per)
        let request = URLRequest.get(url: url)

        let response: PaginatedResponseDTO<MangaDTO> = try await network.execute(request)
        return mangaMapper.mapPaginated(response)
    }

    func getMangasByDemographic(_ demographic: String, page: Int, per: Int) async throws -> PaginatedResponse<Manga> {
        print("📱 APIClient: Getting mangas by demographic '\(demographic)'")

        let url = URL.mangaByDemographic(demographic).withPagination(page: page, per: per)
        let request = URLRequest.get(url: url)

        let response: PaginatedResponseDTO<MangaDTO> = try await network.execute(request)
        return mangaMapper.mapPaginated(response)
    }

    func getMangasByAuthor(_ authorId: String, page: Int, per: Int) async throws -> PaginatedResponse<Manga> {
        print("📱 APIClient: Getting mangas by author '\(authorId)'")

        let url = URL.mangaByAuthor(authorId).withPagination(page: page, per: per)
        let request = URLRequest.get(url: url)

        let response: PaginatedResponseDTO<MangaDTO> = try await network.execute(request)
        return mangaMapper.mapPaginated(response)
    }
}
