//
//  MainScreenPresenter.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 05.01.2023.
//

import Foundation
import Kingfisher

protocol PopularMoviesPresenterProtocol {
    var delegate: PopularMoviesDelegate? { get set }
    
    func loadData()
    func getNumberOfRecords() -> Int
    func getData(for id: Int) -> Movie?
    func itemPressed(for id: Int)
}

final class PopularMoviesPresenter: PopularMoviesPresenterProtocol {
    weak var delegate: PopularMoviesDelegate?
    private let router: RouterProtocol
    private let apiClient: ApiClientProtocol
    private let errorManager: ErrorManagerProtocol = ServiceCoordinator.errorManager
    
    private var movies: [Movie] = []
    
    init(apiClient: ApiClientProtocol, router: RouterProtocol) {
        self.apiClient = apiClient
        self.router = router
    }
    
    func loadData() {
        DispatchQueue.global().async(flags: .barrier) { [weak self] in
            self?.apiClient.getPopularMovies { result in
                switch result {
                case .success(let success):
                    self?.movies = success.movies
                case .failure(let error):
                    let message = "Error - \(error.localizedDescription)"
                    self?.showError(with: message)
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.updateView()
                }
            }
        }
    }
    
    func getNumberOfRecords() -> Int {
        movies.count
    }
    
    func getData(for id: Int) -> Movie? {
        if id < movies.count {
            return movies[id]
        } else {
            return nil
        }
    }
    
    func itemPressed(for id: Int) {
        let movie = movies[id]
        let movieDetailPresenter = MovieDetailPresenter(movie: movie, apiClient: apiClient)
        let detailViewController = MovieDetailViewController(presenter: movieDetailPresenter)

        router.openScreen(detailViewController)
    }
    
    private func showError(with message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let alertController = self?.errorManager.createErrorMessage(message: message) else { return }
            
            self?.delegate?.showErrorAlert(alertController: alertController)
        }
    }
}
