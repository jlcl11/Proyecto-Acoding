//
//  User.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let email: String

    init(id: String = UUID().uuidString, email: String) {
        self.id = id
        self.email = email
    }
}
