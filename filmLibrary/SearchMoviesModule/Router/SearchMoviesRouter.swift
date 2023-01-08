//
//  SearchRouter.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 08.01.2023.
//

import UIKit

protocol SearchMoviesRouterProtocol {
    var navigationController: UINavigationController? { get set }
    
    func openDetailScreen(_ viewController: UIViewController)
}

final class SearchMoviesRouter: SearchMoviesRouterProtocol {
    weak var navigationController: UINavigationController?
    
    func openDetailScreen(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
