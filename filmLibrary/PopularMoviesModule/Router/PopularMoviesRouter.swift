//
//  Router.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 07.01.2023.
//

import UIKit

protocol PopularMoviesRouterProtocol {
    var navigationController: UINavigationController? { get set }
    
    func openDetailScreen(_ viewController: UIViewController)
}

final class PopularMoviesRouter: PopularMoviesRouterProtocol {
    weak var navigationController: UINavigationController?
    
    func openDetailScreen(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
