//
//  SearchRouter.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 08.01.2023.
//

import UIKit

final class SearchMoviesRouter: RouterProtocol {
    weak var navigationController: UINavigationController?
    
    func openScreen(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
