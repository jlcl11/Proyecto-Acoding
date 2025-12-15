//
//  CollectionMapper.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation

struct CollectionMapper {

    private let mangaMapper = MangaMapper()

    func map(_ dto: UserMangaCollectionResponseDTO) -> UserMangaCollection {
        UserMangaCollection(
            id: dto.manga.id,
            manga: mangaMapper.map(dto.manga),
            completeCollection: dto.completeCollection,
            volumesOwned: Set(dto.volumesOwned),
            readingVolume: dto.readingVolume
        )
    }

    func map(_ dtos: [UserMangaCollectionResponseDTO]) -> [UserMangaCollection] {
        dtos.map { map($0) }
    }

    func mapToRequest(
        mangaId: Int,
        completeCollection: Bool,
        volumesOwned: Set<Int>,
        readingVolume: Int?
    ) -> UserMangaCollectionRequestDTO {
        UserMangaCollectionRequestDTO(
            manga: mangaId,
            completeCollection: completeCollection,
            volumesOwned: volumesOwned.sorted(),
            readingVolume: readingVolume
        )
    }
}
