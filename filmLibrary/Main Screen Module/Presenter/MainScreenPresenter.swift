//
//  MainScreenPresenter.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 05.01.2023.
//

import Foundation
import Kingfisher

protocol MainScreenPresenterProtocol {
    var delegate: MainScreenDelegate? { get set }
    
    func loadData(from: Int)
    func getNumberOfRecords() -> Int
    func getData(for id: Int) -> Movie?
}

final class MainScreenPresenter: MainScreenPresenterProtocol {
    weak var delegate: MainScreenDelegate?
    
    private let apiClient: ApiClientProtocol = ServiceCoordinator.apiClient
    private var movies: [Movie] = []
    
    func loadData(from startNumber: Int) {
        let iterations = Constants.downloadDataNumber
        let dispatchGroup = DispatchGroup()
        
        DispatchQueue.concurrentPerform(iterations: iterations) { [weak self] iterationNum in
            dispatchGroup.enter()
            let recordNumber = startNumber + iterationNum
            self?.apiClient.getMovie(byId: recordNumber) { result in
                switch result {
                case .success(let movie):
                    self?.movies.append(movie)
                case .failure(let error):
                    print("Error - \(error.localizedDescription) - \(recordNumber)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.delegate?.updateView()
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
}
