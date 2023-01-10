//
//  SearchPresenter.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 08.01.2023.
//

import UIKit

protocol SearchMoviesDataProtocol {
    func getNumberOfRecords() -> Int
    func getData(by id: Int) -> Movie?
    
    func searchData(withText searchText: String)
    func loadMoreData()
}

protocol SearchMoviesPresenterProtocol: SearchMoviesDataProtocol {
    var delegate: SearchMoviesDelegate? { get set }
    
    func itemPressed(sender: UIViewController, for id: Int)
    func filterButtonPressed(sender: UIViewController)
    func errorAppeared()
}

final class SearchMoviesPresenter: SearchMoviesPresenterProtocol {
    
    // MARK: - Services
    
    private let apiClient: ApiClientProtocol
    private let router: RouterProtocol
    private let errorManager: ErrorManagerProtocol = ServiceCoordinator.errorManager
    
    // MARK: - Parameters
    
    var delegate: SearchMoviesDelegate?
    private var movies: [Movie] = []
    private var pages = 1
    private var currentPage = 1
    private var searchRequest = ""
    
    // MARK: - Inits
    
    init(apiClient: ApiClientProtocol, router: RouterProtocol) {
        self.apiClient = apiClient
        self.router = router
    }
    
    // MARK: - Funcs
    
    func getNumberOfRecords() -> Int {
        movies.count
    }
    
    func searchData(withText searchText: String) {
        delegate?.startLoading()
        searchRequest = searchText
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let currentPage = self?.currentPage else { return }
            
            self?.apiClient.searchMovie(for: searchText, in: currentPage) { [weak self] result in
                switch result {
                case .success(let success):
                    self?.pages = success.pages
                    self?.movies = success.results
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
    
    func loadMoreData() {
        currentPage += 1
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let pages = self?.pages,
                  let currentPage = self?.currentPage,
                  let searchText = self?.searchRequest else { return }
            
            if currentPage <= pages {
                self?.apiClient.searchMovie(for: searchText, in: currentPage) { result in
                    switch result {
                    case .success(let success):
                        self?.movies += success.results
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
    }
    
    func getData(by id: Int) -> Movie? {
        if id < movies.count {
            return movies[id]
        } else {
            return nil
        }
    }
    
    func itemPressed(sender: UIViewController, for id: Int) {
        let movie = movies[id]
        let movieDetailPresenter = MovieDetailPresenter(movie: movie, apiClient: apiClient)
        let detailViewController = MovieDetailViewController(presenter: movieDetailPresenter)

        router.openScreen(detailViewController)
    }
    
    func filterButtonPressed(sender: UIViewController) {
        let movieFilter = ServiceCoordinator.webMovieFilter
        let filterPresenter: FilterPresenterProtocol = FilterPresenter(movieFilter: movieFilter) { [weak self] in
            guard let searchRequest = self?.searchRequest else { return }
            
            self?.searchData(withText: searchRequest)
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
    
    func errorAppeared() {
        let message = "По вашему запросу \(searchRequest) - ничего не найдено. Попробуйте ввести другой запрос."
        showError(with: message)
    }
    
    private func showError(with message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let alertController = self?.errorManager.createErrorMessage(message: message) else {
                return
            }
            
            self?.delegate?.showErrorAlert(alertController: alertController)
        }
    }
}
