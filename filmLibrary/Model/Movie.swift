//
//  Movie.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 05.01.2023.
//

import Foundation

// MARK: - Enum types

enum MovieType: String, Decodable {
    case movie = "movie"
    case tvSeries = "tv-series"
    case cartoon = "cartoon"
    case anime = "anime"
    case animatedSeries = "animated-series"
    case tvShow = "tv-show"
}

enum SexType: String, Decodable {
    case men = "Мужской"
    case women = "Женский"
}

enum ReviewType: String, Decodable {
    case positive = "Положительный"
    case negative = "Негативный"
}

// MARK: - Global struct models

struct Movie: Decodable {
    let id: Int
    let name: String
    let type: MovieType
    let description: String
    let year: Int
    let movieLength: Int
    let rating: Rating
    let poster: Poster
    let genres: [Genre]
    let facts: [Fact]
    //let persons: [ShortPerson]
}

struct Person: Decodable {
    let id: Int
    let name: String
    let photo: String
    let sex: SexType
    let growth: Int
    let birthday: String
    let death: String
    let age: Int
    let profession: Profession
    let facts: [Fact]
    let movies: [ShortMovie]
}

struct Review: Decodable {
    let id: Int
    let movieId: Int
    let title: String
    let type: ReviewType
    let review: String
    let date: String
    let author: String
}

// MARK: - Struct helpers

struct Rating: Decodable {
    let kp: Double?
    let tmdb: Double?
    let imdb: Double?
}

struct Poster: Decodable {
    let url: String
    let previewUrl: String
}

struct Budget: Decodable {
    let value: String
    let currency: String
}

struct Genre: Decodable {
    let name: String
}

struct Fact: Decodable {
    let value: String
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

struct ShortPerson: Decodable {
    let id: Int
    let name: String
    let photo: String
    let enProfession: String
    let personDescription: String?
}
