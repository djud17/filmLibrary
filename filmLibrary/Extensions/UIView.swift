//
//  UIView.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 09.01.2023.
//

import UIKit

extension UIView {
    func setupShadow() {
        layer.shadowColor = Constants.Color.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 20, height: 20)
        layer.shadowRadius = 20
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
