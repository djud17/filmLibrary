//
//  ServiceCoordinator.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 05.01.2023.
//

import Foundation

final class ServiceCoordinator {
    static let apiClient: ApiClientProtocol = ApiClient.shared
    static let webMovieFilter: MovieFilterProtocol = MovieFilter()
    static let deviceMovieFilter: MovieFilterProtocol = MovieFilter()
    static let storage: StorageProtocol = RealmStorage.shared
    static let errorManager: ErrorManagerProtocol = ErrorManager.shared
}
