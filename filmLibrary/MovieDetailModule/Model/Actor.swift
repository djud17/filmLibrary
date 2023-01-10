//
//  Actor.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 08.01.2023.
//

import Foundation

struct SingleMovie: Decodable {
    let id: Int
    let facts: [Fact]
    let persons: [Actor]
}

// MARK: - Fact

struct Fact: Decodable {
    let value: String
}

// MARK: - Person

struct Actor: Decodable {
    let id: Int
    let photo: String?
}
