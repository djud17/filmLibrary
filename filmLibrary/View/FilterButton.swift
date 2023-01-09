//
//  FilterButton.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 10.01.2023.
//

import UIKit

final class FilterButton: UIButton {
    init(with title: String) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(Constants.Color.orange, for: .normal)
        setTitleColor(Constants.Color.orange.withAlphaComponent(0.5), for: .highlighted)
        backgroundColor = Constants.Color.white

        layer.cornerRadius = Constants.Size.cornerRadius
        
        setupShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
