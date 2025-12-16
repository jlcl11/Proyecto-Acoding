//
//  APIConstants.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 16/12/25.
//

import Foundation

enum APIConstants {

    // MARK: - Authentication

    /// App token required for user registration endpoint
    /// Source: PDF "Práctica Mis Mangas" - Page 4
    /// Required in "App-Token" header for POST /users
    static let appToken = "sLGH38NhEJ0_anlIWwhsz1-LarClEohiAHQqayF0FY"

    // MARK: - Base URL

    /// Base URL for the MyManga API
    static let baseURL = "https://mymanga-acacademy-5607149ebe3d.herokuapp.com"
}
