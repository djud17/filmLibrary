//
//  DetailPresenter.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 07.01.2023.
//

import Foundation

protocol MovieDetailLoadDataProtocol {
    func loadData()
    func loadMovieInfo()
}

protocol MovieDetailGetDataProtocol {
    func getNumberOfActors() -> Int
    func getData(for id: Int) -> Actor?
    func getFacts() -> [String]
}

protocol MovieDetailWatchListProtocol {
    func checkWatchList() -> Bool
    func watchListButtonTapped()
}

protocol MovieDetailPresenterProtocol: MovieDetailLoadDataProtocol,
                                       MovieDetailGetDataProtocol,
                                       MovieDetailWatchListProtocol {
    var delegate: MovieDetailDelegate? { get set }
}

final class MovieDetailPresenter: MovieDetailPresenterProtocol {
    
    // MARK: - Services
    
    weak var delegate: MovieDetailDelegate?
    private let apiClient: ApiClientProtocol
    private let storage: StorageProtocol = ServiceCoordinator.storage
    private let errorManager: ErrorManagerProtocol = ServiceCoordinator.errorManager
    
    // MARK: - Parameters
    
    private var movie: Movie
    private var movieFacts: [Fact] = []
    private var actors: [Actor] = []
    
    // MARK: - Inits
    
    init(movie: Movie, apiClient: ApiClientProtocol) {
        self.movie = movie
        self.apiClient = apiClient
    }
    
    // MARK: - Funcs
    
    func loadData() {
        let imageUrl = movie.poster?.previewUrl
        delegate?.setupPosterImage(with: imageUrl ?? "")
        
        delegate?.setupMovieName(with: movie.name)
        delegate?.setupMovieDescription(with: movie.description ?? "")
        
        var info = "\(movie.rating.kinopoisk)"
        if let duration = movie.movieLength {
            info += ", \(duration) мин."
        }
        if let year = movie.year {
            info += ", \(year) г."
        }
        delegate?.setupInfoBlock(with: info)
    }
    
    func getNumberOfActors() -> Int {
        actors.count
    }
    
    func loadMovieInfo() {
        let movieId = movie.id
        
        DispatchQueue.global().async(flags: .barrier) { [weak self] in
            self?.apiClient.getMovie(by: movieId) { result in
                switch result {
                case .success(let success):
                    if let actors = success.persons {
                        self?.actors = actors
                    }
                    if let facts = success.facts {
                        self?.movieFacts = facts
                    }
                case .failure(let error):
                    let message = "Ошибка во время загрузки детальной информации о фильме - \(error.localizedDescription)"
                    self?.showError(with: message)
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.updateActorsBlock()
                    self?.delegate?.setupFactsBlock()
                }
            }
        }
    }
    
    func getData(for id: Int) -> Actor? {
        if id < actors.count {
            return actors[id]
        } else {
            return nil
        }
    }
    
    func getFacts() -> [String] {
        var randomFacts = [String]()
        
        if movieFacts.count > 0 {
            for _ in 0..<7 {
                let index = Int.random(in: 0..<movieFacts.count)
                let fact = cleanFact(fact: movieFacts[index].value)
                randomFacts.append(fact)
            }
        }
        
        let set = Set(randomFacts)
        return Array(set)
    }
    
    private func cleanFact(fact: String) -> String {
        var cleanFact = fact
        var needCheck = true
        
        while needCheck {
            if let firstIndex = cleanFact.firstIndex(of: "<"),
               let lastIndex = cleanFact.firstIndex(of: ">") {
                cleanFact.removeSubrange(firstIndex...lastIndex)
            } else if let firstIndex = cleanFact.firstIndex(of: "&"),
                 let lastIndex = cleanFact.firstIndex(of: ";") {
                cleanFact.removeSubrange(firstIndex...lastIndex)
            } else {
                needCheck = false
            }
        }
        
        return cleanFact
    }
    
    func checkWatchList() -> Bool {
        storage.checkItemIn(by: movie.id)
    }
    
    func watchListButtonTapped() {
        if checkWatchList() {
            deleteFromStorage()
        } else {
            writeToStorage()
        }
    }
    
    private func deleteFromStorage() {
        do {
            try storage.deleteFrom(by: movie.id)
        } catch {
            let message = "Ошибка во время удаления объекта из хранилища - \(error.localizedDescription)"
            showError(with: message)
        }
    }
    
    private func writeToStorage() {
        do {
            try storage.writeTo(object: movie)
        } catch {
            let message = "Ошибка во время записи объекта в хранилище - \(error.localizedDescription)"
            showError(with: message)
        }
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
