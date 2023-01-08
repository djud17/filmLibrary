//
//  Router.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 07.01.2023.
//

import UIKit

protocol PopularMoviesRouterProtocol {
    var navigationController: UINavigationController? { get }
    
    func openDetailScreen(_ viewController: UIViewController)
}

final class PopularMoviesRouter: PopularMoviesRouterProtocol {
    var navigationController: UINavigationController?
    
    func openDetailScreen(_ viewController: UIViewController) {
        navigationController?.modalPresentationStyle = .formSheet
        navigationController?.pushViewController(viewController, animated: true)
    }
}
