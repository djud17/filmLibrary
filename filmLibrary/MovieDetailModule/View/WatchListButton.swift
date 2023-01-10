//
//  WatchListButton.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 10.01.2023.
//

import UIKit

enum WatchListButtonStyle {
    case added
    case notAdded
}

final class WatchListButton: UIButton {
    var buttonStyle: WatchListButtonStyle {
        didSet {
            setStyle()
        }
    }
    
    init(buttonStyle: WatchListButtonStyle) {
        self.buttonStyle = buttonStyle
        super.init(frame: .zero)
        
        tintColor = Constants.Color.red
        backgroundColor = Constants.Color.white
        layer.cornerRadius = Constants.Size.watchListButton / 2
        
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        let image: UIImage?
        switch buttonStyle {
        case .added:
            image = UIImage(systemName: Constants.ImageName.watchListButtonSelected)
        case .notAdded:
            image = UIImage(systemName: Constants.ImageName.watchListButton)
        }
        
        setBackgroundImage(image, for: .normal)
    }
}
