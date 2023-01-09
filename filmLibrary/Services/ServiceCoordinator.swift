//
//  ServiceCoordinator.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 05.01.2023.
//

import Foundation

protocol ServiceCoordinatorProtocol {
    static var apiClient: ApiClientProtocol { get }
    static var movieFilter: MovieFilterProtocol { get }
}

final class ServiceCoordinator: ServiceCoordinatorProtocol {
    static let apiClient: ApiClientProtocol = ApiClient()
    static let movieFilter: MovieFilterProtocol = MovieFilter()
}
