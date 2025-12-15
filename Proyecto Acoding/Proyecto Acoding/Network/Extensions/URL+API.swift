//
//  URL+API.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation

extension URL {

    // MARK: - Base URL

    static let apiBase = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com")!

    // MARK: - List Endpoints

    static var mangaList: URL {
        apiBase.appendingPathComponent("list/mangas")
    }

    static var bestMangas: URL {
        apiBase.appendingPathComponent("list/bestMangas")
    }

    static var authors: URL {
        apiBase.appendingPathComponent("list/authors")
    }

    static var demographics: URL {
        apiBase.appendingPathComponent("list/demographics")
    }

    static var genres: URL {
        apiBase.appendingPathComponent("list/genres")
    }

    static var themes: URL {
        apiBase.appendingPathComponent("list/themes")
    }

    static func mangaByGenre(_ genre: String) -> URL {
        apiBase.appendingPathComponent("list/mangaByGenre/\(genre)")
    }

    static func mangaByDemographic(_ demographic: String) -> URL {
        apiBase.appendingPathComponent("list/mangaByDemographic/\(demographic)")
    }

    static func mangaByTheme(_ theme: String) -> URL {
        apiBase.appendingPathComponent("list/mangaByTheme/\(theme)")
    }

    static func mangaByAuthor(_ authorId: String) -> URL {
        apiBase.appendingPathComponent("list/mangaByAuthor/\(authorId)")
    }

    // MARK: - Search Endpoints

    static func manga(id: Int) -> URL {
        apiBase.appendingPathComponent("search/manga/\(id)")
    }

    static var customSearch: URL {
        apiBase.appendingPathComponent("search/manga")
    }

    // MARK: - Pagination Helper

    func withPagination(page: Int, per: Int = 10) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per", value: "\(per)")
        ]
        return components.url!
    }
}
