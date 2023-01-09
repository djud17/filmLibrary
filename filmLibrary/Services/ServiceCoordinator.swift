//
//  ServiceCoordinator.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 05.01.2023.
//

import Foundation

final class ServiceCoordinator {
    static let apiClient: ApiClientProtocol = ApiClient()
    static let movieFilter: MovieFilterProtocol = MovieFilter()
}
