//
//  SearchPresenter.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 08.01.2023.
//

import UIKit

protocol SearchMoviesPresenterProtocol {
    var delegate: SearchMoviesDelegate? { get set }
    
    func getNumberOfRecords() -> Int
    func searchData(withText searchText: String)
    func getData(by id: Int) -> Movie?
    func loadMoreData()
    func itemPressed(sender: UIViewController, for id: Int)
}

final class SearchMoviesPresenter: SearchMoviesPresenterProtocol {
    var delegate: SearchMoviesDelegate?
    private let apiClient: ApiClientProtocol
    private let router: SearchMoviesRouterProtocol
    private var movies: [Movie] = []
    private var pages = 1
    private var currentPage = 1
    private var searchRequest = ""
    
    init(apiClient: ApiClientProtocol, router: SearchMoviesRouterProtocol) {
        self.apiClient = apiClient
        self.router = router
    }
    
    func getNumberOfRecords() -> Int {
        movies.count
    }
    
    func searchData(withText searchText: String) {
        searchRequest = searchText
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let currentPage = self?.currentPage else { return }
            
            self?.apiClient.searchMovie(for: searchText, in: currentPage) { [weak self] result in
                switch result {
                case .success(let success):
                    self?.pages = success.pages
                    self?.movies = success.results
                case .failure(let error):
                    print("Error - \(error.localizedDescription)")
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
                self?.apiClient.searchMovie(for: searchText, in: currentPage) { [weak self] result in
                    switch result {
                    case .success(let success):
                        self?.movies += success.results
                    case .failure(let error):
                        print("Error - \(error.localizedDescription)")
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

        router.openDetailScreen(detailViewController)
    }
}
