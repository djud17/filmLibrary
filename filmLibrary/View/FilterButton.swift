//
//  FilterButton.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 10.01.2023.
//

import UIKit

final class FilterButton: UIButton {
    init() {
        super.init(frame: .zero)
        
        tintColor = Constants.Color.orange
        backgroundColor = Constants.Color.white
        layer.cornerRadius = Constants.Size.filterButton / 2
        
        setBackgroundImage(UIImage(systemName: Constants.ImageName.filterButton), for: .normal)
        
        setupShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
