//
//  File.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 10.01.2023.
//

import UIKit

final class WatchListRouter: RouterProtocol {
    weak var navigationController: UINavigationController?
    
    func openScreen(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
