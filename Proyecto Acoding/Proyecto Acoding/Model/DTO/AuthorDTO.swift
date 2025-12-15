//
//  AuthorDTO.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation

struct AuthorDTO: Codable, Hashable {
    let id: String
    let firstName: String
    let lastName: String
    let role: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case role
    }
}
