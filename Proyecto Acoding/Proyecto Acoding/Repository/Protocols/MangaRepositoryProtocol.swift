//
//  MangaRepositoryProtocol.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation

protocol MangaRepositoryProtocol {
    // List
    func getMangas(page: Int, per: Int) async throws -> PaginatedResponse<Manga>
    func getBestMangas(page: Int, per: Int) async throws -> PaginatedResponse<Manga>
    func getManga(id: Int) async throws -> Manga

    // Search
    func searchMangas(query: CustomSearchDTO, page: Int, per: Int) async throws -> PaginatedResponse<Manga>

    // Filters
    func getGenres() async throws -> [String]
    func getThemes() async throws -> [String]
    func getDemographics() async throws -> [String]
    func getAuthors() async throws -> [Author]

    // Filter by category
    func getMangasByGenre(_ genre: String, page: Int, per: Int) async throws -> PaginatedResponse<Manga>
    func getMangasByTheme(_ theme: String, page: Int, per: Int) async throws -> PaginatedResponse<Manga>
    func getMangasByDemographic(_ demographic: String, page: Int, per: Int) async throws -> PaginatedResponse<Manga>
    func getMangasByAuthor(_ authorId: String, page: Int, per: Int) async throws -> PaginatedResponse<Manga>
}
