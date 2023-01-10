//
//  WatchListPresenter.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 10.01.2023.
//

import UIKit

protocol WatchListPresenterProtocol {
    var delegate: WatchListDelegate? { get set }
    
    func getNumberOfRecords() -> Int
    func loadData()
    func getData(by id: Int) -> Movie?
    func itemPressed(sender: UIViewController, for id: Int)
    func filterButtonPressed(sender: UIViewController)
    func deleteObject(by id: Int)
}

final class WatchListPresenter: WatchListPresenterProtocol {
    
    // MARK: - Parameters
    
    weak var delegate: WatchListDelegate?
    private let storage: StorageProtocol = ServiceCoordinator.storage
    private let errorManager: ErrorManagerProtocol = ServiceCoordinator.errorManager
    private let router: RouterProtocol
    private let apiClient: ApiClientProtocol
    private let movieFilter = ServiceCoordinator.deviceMovieFilter
    
    private var watchListMovies: [Movie] = [] {
        didSet {
            watchListMovies = watchListMovies.sorted { $0.name < $1.name}
        }
    }
    
    // MARK: - Inits
    
    init(router: RouterProtocol, apiClient: ApiClientProtocol) {
        self.router = router
        self.apiClient = apiClient
    }
    
    func getNumberOfRecords() -> Int {
        watchListMovies.count
    }
    
    func loadData() {
        DispatchQueue.main.async { [weak self] in
            guard let movies = self?.storage.readFrom() else { return }
            
            self?.watchListMovies = movies            
            self?.updateDataWithFilters()
        }
    }
    
    func updateDataWithFilters() {
        var minimalRating: Float = 0
        var minimalYear = 1900
        if let rating = movieFilter.rating {
            minimalRating = rating.lowerBound
        }
        
        if let year = movieFilter.year {
            minimalYear = year.lowerBound
        }
        
        watchListMovies = watchListMovies.filter { $0.rating.kinopoisk >= Double(minimalRating) }.filter {
            guard let year = $0.year else { return false }
            
            return year >= minimalYear
        }
        delegate?.updateView()
    }
    
    func getData(by id: Int) -> Movie? {
        if id < watchListMovies.count {
            return watchListMovies[id]
        } else {
            return nil
        }
    }
    
    func itemPressed(sender: UIViewController, for id: Int) {
        let movie = watchListMovies[id]
        let movieDetailPresenter = MovieDetailPresenter(movie: movie, apiClient: apiClient)
        let detailViewController = MovieDetailViewController(presenter: movieDetailPresenter)

        router.openScreen(detailViewController)
    }
    
    private func showError(with message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let alertController = self?.errorManager.createErrorMessage(message: message) else {
                return
            }
            
            self?.delegate?.showErrorAlert(alertController: alertController)
        }
    }
    
    func filterButtonPressed(sender: UIViewController) {
        let filterPresenter: FilterPresenterProtocol = FilterPresenter(movieFilter: movieFilter) { [weak self] in
            self?.loadData()
        }
        
        let filterViewController = FilterViewController(presenter: filterPresenter)
        filterViewController.modalPresentationStyle = .pageSheet
        
        if #available(iOS 15.0, *) {
            if let sheet = filterViewController.sheetPresentationController {
                sheet.detents = [.medium()]
            }
        }
        
        sender.present(filterViewController, animated: true)
    }
    
    func deleteObject(by id: Int) {
        let movieId = watchListMovies[id].id
        
        do {
            try storage.deleteFrom(by: movieId)
            watchListMovies.remove(at: id)
        } catch {
            let message = "Error - \(error.localizedDescription)"
            showError(with: message)
        }
    }
}
