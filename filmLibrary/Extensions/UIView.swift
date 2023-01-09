//
//  UIView.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 09.01.2023.
//

import UIKit

extension UIView {
    func setupShadow() {
        self.layer.shadowColor = Constants.Color.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 20, height: 20)
        self.layer.shadowRadius = 20
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
