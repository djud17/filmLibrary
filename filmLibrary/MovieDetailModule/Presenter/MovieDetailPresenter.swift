//
//  DetailPresenter.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 07.01.2023.
//

import Foundation

protocol MovieDetailPresenterProtocol {
    var delegate: MovieDetailDelegate? { get set }
    
    func loadData()
    func getNumberOfActors() -> Int
    func getData(for id: Int) -> Actor?
    func loadMovieInfo()
    func getFacts() -> [String]
}

final class MovieDetailPresenter: MovieDetailPresenterProtocol {
    private var movie: Movie
    weak var delegate: MovieDetailDelegate?
    private let apiClient: ApiClientProtocol
    private var movieFacts: [Fact] = []
    private var actors: [Actor] = []
    
    init(movie: Movie, apiClient: ApiClientProtocol) {
        self.movie = movie
        self.apiClient = apiClient
    }
    
    func loadData() {
        let imageUrl = movie.poster?.previewUrl
        delegate?.setupPosterImage(with: imageUrl ?? "")
        delegate?.setupMovieName(with: movie.name + " (\(movie.year))")
        delegate?.setupMovieDescription(with: movie.description ?? "")
        delegate?.setupInfoBlock(rating: movie.rating.kinopoisk, duration: movie.movieLength ?? 0)
    }
    
    func getNumberOfActors() -> Int {
        actors.count
    }
    
    func loadMovieInfo() {
        let movieId = movie.id
        
        DispatchQueue.global().async(flags: .barrier) { [weak self] in
            self?.apiClient.getMovie(by: movieId) { [weak self] result in
                switch result {
                case .success(let success):
                    self?.actors = success.persons
                    self?.movieFacts = success.facts
                case .failure(let error):
                    print("Error - \(error.localizedDescription)")
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
}
