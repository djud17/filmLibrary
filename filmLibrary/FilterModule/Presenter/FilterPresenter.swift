//
//  FilterPresenter.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 09.01.2023.
//

import Foundation

protocol FilterPresenterProtocol {
    var delegate: FilterDelegate? { get set }
    
    func getFilterValues() -> (Int, Double)
    func filterSubmit(yearRange: ClosedRange<Int>?, ratingRange: ClosedRange<Double>?)
}

final class FilterPresenter: FilterPresenterProtocol {
    weak var delegate: FilterDelegate?
    
    private var movieFilter: MovieFilterProtocol
    private var completion: () -> Void
    
    init(movieFilter: MovieFilterProtocol, completion: @escaping () -> Void) {
        self.movieFilter = movieFilter
        self.completion = completion
    }
    
    func getFilterValues() -> (Int, Double) {
        var initialYear = 0
        var initialRating: Double = 0
        
        if let year = movieFilter.year?.lowerBound {
            initialYear = year
        }
        if let rating = movieFilter.rating?.lowerBound {
            initialRating = rating
        }
        
        return (initialYear, initialRating)
    }
    
    func filterSubmit(yearRange: ClosedRange<Int>?, ratingRange: ClosedRange<Double>?) {
        movieFilter.year = yearRange
        movieFilter.rating = ratingRange
        
        completion()
    }
}
