//
//  Movie.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 05.01.2023.
//

import Foundation

// MARK: - Movie
struct Movie: Decodable {
    let poster: Poster?
    let rating: Rating
    let movieLength: Int?
    let id: Int
    let name: String
    let description: String?
    let year: Int?
    let shortDescription: String?
}

// MARK: - Poster
struct Poster: Decodable {
    let previewUrl: String
}

// MARK: - Rating
struct Rating: Decodable {
    let kinopoisk: Double
    
    enum CodingKeys: String, CodingKey {
        case kinopoisk = "kp"
    }
}
