//
//  UserDTO.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import Foundation

struct UserDTO: Codable {
    let email: String
    let password: String
}

struct TokenResponseDTO: Codable {
    let token: String
}
