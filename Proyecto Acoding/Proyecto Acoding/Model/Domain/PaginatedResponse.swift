//
//  PaginatedResponse.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation

struct PaginatedResponse<T> {
    let items: [T]
    let metadata: PaginationMetadata

    var isEmpty: Bool {
        items.isEmpty
    }

    var hasMorePages: Bool {
        metadata.currentPage < metadata.totalPages
    }

    var isFirstPage: Bool {
        metadata.currentPage == 1
    }

    var isLastPage: Bool {
        metadata.currentPage >= metadata.totalPages
    }
}

struct PaginationMetadata {
    let total: Int
    let currentPage: Int
    let itemsPerPage: Int

    var totalPages: Int {
        guard itemsPerPage > 0 else { return 0 }
        return Int(ceil(Double(total) / Double(itemsPerPage)))
    }

    var hasNextPage: Bool {
        currentPage < totalPages
    }

    var hasPreviousPage: Bool {
        currentPage > 1
    }

    var displayRange: String {
        let start = (currentPage - 1) * itemsPerPage + 1
        let end = min(currentPage * itemsPerPage, total)
        return "\(start)-\(end) de \(total)"
    }
}
