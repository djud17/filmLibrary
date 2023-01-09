//
//  NavigationController.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 08.01.2023.
//

import UIKit

extension UINavigationController {
    func setupControllerStyle() {
        self.navigationBar.prefersLargeTitles = true
        self.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Constants.Color.white
        ]
        self.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Constants.Color.orange
        ]
        self.navigationBar.tintColor = Constants.Color.white
    }
}
