//
//  CacheManager.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation

/// Simple in-memory cache with expiration
actor CacheManager {

    static let shared = CacheManager()

    private init() {}

    // MARK: - Cache Entry

    private struct CacheEntry<T> {
        let value: T
        let expirationDate: Date

        var isExpired: Bool {
            Date() > expirationDate
        }
    }

    // MARK: - Storage

    private var cache: [String: Any] = [:]

    // MARK: - Cache Operations

    func set<T>(_ value: T, forKey key: String, expirationTime: TimeInterval = 300) {
        let expirationDate = Date().addingTimeInterval(expirationTime)
        let entry = CacheEntry(value: value, expirationDate: expirationDate)
        cache[key] = entry
        print("💾 CacheManager: Cached '\(key)' (expires in \(expirationTime)s)")
    }

    func get<T>(forKey key: String) -> T? {
        guard let entry = cache[key] as? CacheEntry<T> else {
            print("❌ CacheManager: Cache miss for '\(key)'")
            return nil
        }

        if entry.isExpired {
            cache.removeValue(forKey: key)
            print("⏰ CacheManager: Cache expired for '\(key)'")
            return nil
        }

        print("✅ CacheManager: Cache hit for '\(key)'")
        return entry.value
    }

    func remove(forKey key: String) {
        cache.removeValue(forKey: key)
        print("🗑️ CacheManager: Removed cache for '\(key)'")
    }

    func clear() {
        cache.removeAll()
        print("🧹 CacheManager: Cleared all cache")
    }

    func removeExpired() {
        let keysToRemove = cache.keys.filter { key in
            if let entry = cache[key] as? CacheEntry<Any> {
                return entry.isExpired
            }
            return false
        }

        keysToRemove.forEach { cache.removeValue(forKey: $0) }

        if !keysToRemove.isEmpty {
            print("🧹 CacheManager: Removed \(keysToRemove.count) expired entries")
        }
    }
}

// MARK: - Cache Keys

enum CacheKey {
    static func mangaList(page: Int, per: Int) -> String {
        "manga_list_page_\(page)_per_\(per)"
    }

    static func bestMangas(page: Int, per: Int) -> String {
        "best_mangas_page_\(page)_per_\(per)"
    }

    static func manga(id: Int) -> String {
        "manga_\(id)"
    }

    static func search(query: CustomSearchDTO, page: Int, per: Int) -> String {
        var components: [String] = []

        if let title = query.searchTitle {
            components.append("title:\(title)")
        }
        if let firstName = query.searchAuthorFirstName {
            components.append("firstName:\(firstName)")
        }
        if let lastName = query.searchAuthorLastName {
            components.append("lastName:\(lastName)")
        }
        if let genres = query.searchGenres {
            components.append("genres:\(genres.joined(separator: ","))")
        }
        if let themes = query.searchThemes {
            components.append("themes:\(themes.joined(separator: ","))")
        }
        if let demographics = query.searchDemographics {
            components.append("demographics:\(demographics.joined(separator: ","))")
        }

        let queryString = components.joined(separator: "_")
        return "search_\(queryString)_page_\(page)_per_\(per)"
    }
}
