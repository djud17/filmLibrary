//
//  MovieFilter.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 09.01.2023.
//

import Foundation

protocol MovieFilterProtocol {
    var rating: ClosedRange<Float>? { get set }
    var year: ClosedRange<Int>? { get set }
    
    func resetFilter()
}

final class MovieFilter: MovieFilterProtocol {
    var rating: ClosedRange<Float>?
    var year: ClosedRange<Int>?
    
    func resetFilter() {
        rating = nil
        year = nil
    }
}
