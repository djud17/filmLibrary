//
//  Router.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 07.01.2023.
//

import UIKit

protocol RouterProtocol {
    var navigationController: UINavigationController? { get set }
    
    func openScreen(_ viewController: UIViewController)
}

final class PopularMoviesRouter: RouterProtocol {
    weak var navigationController: UINavigationController?
    
    func openScreen(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
