//
//  UserMangaCollection.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation

struct UserMangaCollection: Identifiable, Hashable {
    let id: Int  // Mismo ID que el manga
    let manga: Manga
    let completeCollection: Bool
    let volumesOwned: Set<Int>
    let readingVolume: Int?

    var ownedCount: Int {
        volumesOwned.count
    }

    var totalVolumes: Int {
        manga.totalVolumes ?? 0
    }

    var collectionProgress: Double {
        guard totalVolumes > 0 else { return 0 }
        return Double(ownedCount) / Double(totalVolumes)
    }

    var readingProgress: Double {
        guard totalVolumes > 0, let reading = readingVolume else { return 0 }
        return Double(reading) / Double(totalVolumes)
    }

    var formattedProgress: String {
        if completeCollection {
            return "Colección completa"
        }
        return "\(ownedCount)/\(totalVolumes) tomos"
    }

    var formattedReadingStatus: String {
        guard let volume = readingVolume else {
            return "No iniciado"
        }
        return "Leyendo tomo \(volume)"
    }

    var missingVolumes: [Int] {
        guard let total = manga.totalVolumes else { return [] }
        let allVolumes = Set(1...total)
        return allVolumes.subtracting(volumesOwned).sorted()
    }
}
