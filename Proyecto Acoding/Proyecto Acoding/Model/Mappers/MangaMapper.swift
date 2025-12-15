//
//  MangaMapper.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation

struct MangaMapper {

    private let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    // MARK: - Single Manga Mapping

    func map(_ dto: MangaDTO) -> Manga {
        Manga(
            id: dto.id,
            title: dto.title,
            japaneseTitle: dto.titleJapanese,
            englishTitle: dto.titleEnglish,
            score: dto.score ?? 0.0,
            status: mapStatus(dto.status),
            startDate: parseDate(dto.startDate),
            endDate: parseDate(dto.endDate),
            totalChapters: dto.chapters,
            totalVolumes: dto.volumes,
            synopsis: dto.sypnosis ?? "Sin sinopsis disponible",
            background: dto.background,
            coverImageURL: parseImageURL(dto.mainPicture),
            externalURL: parseURL(dto.url),
            authors: dto.authors.map { mapAuthor($0) },
            genres: dto.genres.map { mapGenre($0) },
            themes: dto.themes.map { mapTheme($0) },
            demographics: dto.demographics.map { mapDemographic($0) }
        )
    }

    // MARK: - Collection Mapping

    func map(_ dtos: [MangaDTO]) -> [Manga] {
        dtos.map { map($0) }
    }

    func mapPaginated(_ dto: PaginatedResponseDTO<MangaDTO>) -> PaginatedResponse<Manga> {
        PaginatedResponse(
            items: map(dto.items),
            metadata: PaginationMetadata(
                total: dto.metadata.total,
                currentPage: dto.metadata.page,
                itemsPerPage: dto.metadata.per
            )
        )
    }

    // MARK: - Private Helpers

    private func mapStatus(_ status: String?) -> MangaStatus {
        guard let status = status else { return .unknown }
        return MangaStatus(rawValue: status) ?? .unknown
    }

    private func parseDate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        return dateFormatter.date(from: dateString)
    }

    private func parseImageURL(_ urlString: String?) -> URL? {
        guard let urlString = urlString else { return nil }
        // La API a veces devuelve URLs con comillas extras
        let cleanedURL = urlString
            .trimmingCharacters(in: .init(charactersIn: "\""))
            .trimmingCharacters(in: .whitespaces)
        return URL(string: cleanedURL)
    }

    private func parseURL(_ urlString: String?) -> URL? {
        guard let urlString = urlString else { return nil }
        let cleanedURL = urlString.trimmingCharacters(in: .init(charactersIn: "\""))
        return URL(string: cleanedURL)
    }

    private func mapAuthor(_ dto: AuthorDTO) -> Author {
        Author(
            id: dto.id,
            firstName: dto.firstName,
            lastName: dto.lastName,
            role: AuthorRole(rawValue: dto.role) ?? .unknown
        )
    }

    private func mapGenre(_ dto: GenreDTO) -> Genre {
        Genre(id: dto.id, name: dto.genre)
    }

    private func mapTheme(_ dto: ThemeDTO) -> Theme {
        Theme(id: dto.id, name: dto.theme)
    }

    private func mapDemographic(_ dto: DemographicDTO) -> Demographic {
        Demographic(id: dto.id, name: dto.demographic)
    }
}
