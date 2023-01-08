//
//  Constants.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 05.01.2023.
//

import UIKit

enum Constants {
    static let downloadDataNumber = 50
    
    enum ApiRequest {
        static let mainUrl = "https://api.kinopoisk.dev/"
        static let token = "0GFAXYE-3SZ4R0N-MYN7XYM-CBA3V83"
    }
    
    enum Color {
        static let white: UIColor = .white
        static let orange = UIColor(red: 0.95, green: 0.46, blue: 0, alpha: 1)
    }
    
    enum Offset {
        static let small: CGFloat = 10
        static let medium: CGFloat = 20
        static let large: CGFloat = 40
    }
    
    enum Size {
        static let imageHeight: CGFloat = 170
        static let imageWidth: CGFloat = 120
        static let smallImageHeight: CGFloat = 130
        
        static let cornerRadius: CGFloat = 15
    }
    
    enum FontSize {
        static let titleLabel: CGFloat = 18
        static let textLabel: CGFloat = 17
    }
}
