//
//  MovieFilter.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 09.01.2023.
//

import Foundation

protocol MovieFilterProtocol {
    var rating: ClosedRange<Double>? { get set }
    var year: ClosedRange<Int>? { get set }
    
    func getFiltersRequest() -> String
}

final class MovieFilter: MovieFilterProtocol {
    var rating: ClosedRange<Double>?
    var year: ClosedRange<Int>?
    
    func getFiltersRequest() -> String {
        var resultRequest = ""
        if let rating = rating {
            let min = rating.lowerBound
            let max = rating.upperBound
            resultRequest += "&field=rating.kp&search=\(min)-\(max)"
        }
        
        if let year = year {
            let min = year.lowerBound
            let max = year.upperBound
            resultRequest += "&field=year&search=\(min)-\(max)"
        }
        
        return resultRequest
    }
}
