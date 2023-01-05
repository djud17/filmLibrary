//
//  Movie.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 05.01.2023.
//

import Foundation

// MARK: - Enum types

enum MovieType {
    case movie
    case tvSeries
    case cartoon
    case anime
    case animatedSeries
    case tvShow
}

enum SexType {
    case men
    case women
}

enum ReviewType {
    case positive
    case negative
}

// MARK: - Global struct models

struct Movie: Decodable {
    let id: Int
    let name: String
    let type: String
    let description: String
    let year: Int
    let movieLength: Int
    let rating: Rating
    let poster: Poster
    let genres: [Genre]
    let facts: [Fact]
    let persons: [Person]
    
    var movieType: MovieType? {
        switch type {
        case "movie":
            return .movie
        case "tv-series":
            return .tvSeries
        case "cartoon":
            return .cartoon
        case "anime":
            return .anime
        case "animated-series":
            return .animatedSeries
        case "tv-show":
            return .tvShow
        default:
            return nil
        }
    }
}

struct Person: Decodable {
    let id: Int
    let name: String
    let photo: String
    let sex: String
    let growth: Int
    let birthday: String
    let death: String
    let age: Int
    let profession: Profession
    let facts: [Fact]
    let movies: [ShortMovie]
    
    var sexType: SexType? {
        switch sex {
        case "Мужской":
            return .men
        case "Женский":
            return .women
        default:
            return nil
        }
    }
}

struct Review: Decodable {
    let id: Int
    let movieId: Int
    let title: String
    let type: String
    let review: String
    let date: String
    let author: String
    
    var reviewType: ReviewType? {
        switch type {
        case "Негативный":
            return .negative
        case "Положительный":
            return .positive
        default:
            return nil
        }
    }
}

// MARK: - Struct helpers

struct Rating: Decodable {
    let kp: Int
    let tmdb: Int
    let imdb: Int
}

struct Poster: Decodable {
    let url: String
    let prevUrl: String
}

struct Budget: Decodable {
    let value: String
    let currency: String
}

struct Genre: Decodable {
    let name: String
}

struct Fact: Decodable {
    let name: String
}

struct Profession: Decodable {
    let value: String
}

struct ShortMovie: Decodable {
    let id: Int
    let name: String
    let rating: Double
    let description: String
}
