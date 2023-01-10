//
//  FilterPresenter.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 09.01.2023.
//

import Foundation

protocol FilterPresenterProtocol {
    func getFilterValues() -> (Int, Float)
    func filterSubmit(yearRange: ClosedRange<Int>?, ratingRange: ClosedRange<Float>?)
    func filterReset()
}

final class FilterPresenter: FilterPresenterProtocol {
    private var movieFilter: MovieFilterProtocol
    private var completion: () -> Void
    
    init(movieFilter: MovieFilterProtocol, completion: @escaping () -> Void) {
        self.movieFilter = movieFilter
        self.completion = completion
    }
    
    func getFilterValues() -> (Int, Float) {
        var initialYear = 0
        var initialRating: Float = 0
        
        if let year = movieFilter.year?.lowerBound {
            initialYear = year
        }
        if let rating = movieFilter.rating?.lowerBound {
            initialRating = rating
        }
        
        return (initialYear, initialRating)
    }
    
    func filterSubmit(yearRange: ClosedRange<Int>?, ratingRange: ClosedRange<Float>?) {
        movieFilter.year = yearRange
        movieFilter.rating = ratingRange
        
        completion()
    }
    
    func filterReset() {
        movieFilter.resetFilter()
    }
}
