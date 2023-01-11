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
    
    // MARK: - Services
    
    private var movieFilter: MovieFilterProtocol
    
    // MARK: - Parameters
    
    private var completion: () -> Void
    
    // MARK: - Inits
    
    init(movieFilter: MovieFilterProtocol, completion: @escaping () -> Void) {
        self.movieFilter = movieFilter
        self.completion = completion
    }
    
    // MARK: - Funcs
    
    func getFilterValues() -> (Int, Float) {
        var initialYear = Constants.Filter.minYear
        var initialRating = Constants.Filter.minRating
        
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
        
        completion()
    }
}
