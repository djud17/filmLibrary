//
//  ServiceCoordinator.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 05.01.2023.
//

import Foundation

final class ServiceCoordinator {
    static let apiClient: ApiClientProtocol = ApiClient.shared
    static let movieFilter: MovieFilterProtocol = MovieFilter.shared
    static let storage: StorageProtocol = RealmStorage.shared
    static let errorManager: ErrorManagerProtocol = ErrorManager.shared
}
