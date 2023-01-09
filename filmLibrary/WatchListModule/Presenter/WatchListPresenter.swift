//
//  WatchListPresenter.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 10.01.2023.
//

import Foundation

protocol WatchListPresenterProtocol {
    var delegate: WatchListDelegate? { get set }
    
    func getNumberOfRecords() -> Int
}

final class WatchListPresenter: WatchListPresenterProtocol {
    weak var delegate: WatchListDelegate?
    private var watchListMovies: [Movie] = []
    
    func getNumberOfRecords() -> Int {
        watchListMovies.count
    }
}
