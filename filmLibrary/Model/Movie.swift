//
//  Movie.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 05.01.2023.
//

import Foundation

// MARK: - PopularMovies
struct PopularMovies: Decodable {
    let movies: [Movie]
}

// MARK: - Movie
struct Movie: Decodable {
    let poster: Poster
    let rating: Rating
    let movieLength, id: Int
    let type: MovieType
    let name, description: String
    let year: Int
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

enum MovieType: String, Decodable {
    case movie = "movie"
    case tvSeries = "tv-series"
    case cartoon = "cartoon"
    case anime = "anime"
    case animatedSeries = "animated-series"
    case tvShow = "tv-show"
}
