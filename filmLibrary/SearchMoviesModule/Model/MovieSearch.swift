//
//  SearchRequest.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 08.01.2023.
//

import Foundation

// MARK: - MovieSearch

struct MovieSearch: Decodable {
    let results: [Movie]
    let pages: Int
    
    enum CodingKeys: String, CodingKey {
        case results = "docs"
        case pages
    }
}
