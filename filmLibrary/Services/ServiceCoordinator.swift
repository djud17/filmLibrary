//
//  ServiceCoordinator.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 05.01.2023.
//

import Foundation

protocol ServiceCoordinatorProtocol {
    static var shared: ServiceCoordinatorProtocol { get }
    
    var apiClient: ApiClientProtocol { get }
}

final class ServiceCoordinator: ServiceCoordinatorProtocol {
    static let shared: ServiceCoordinatorProtocol = ServiceCoordinator()
    
    let apiClient: ApiClientProtocol = ApiClient()
}
