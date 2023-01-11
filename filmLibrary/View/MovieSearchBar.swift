//
//  MovieSearchBar.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 10.01.2023.
//

import UIKit

final class MovieSearchBar: UISearchBar {
    init(with text: String) {
        super.init(frame: .zero)
        
        barTintColor = Constants.Color.white
        keyboardAppearance = .light
        returnKeyType = .search
        placeholder = text
        textField?.backgroundColor = Constants.Color.white
        clearBackgroundColor()
        setupShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
