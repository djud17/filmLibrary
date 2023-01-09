//
//  Constants.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 05.01.2023.
//

import UIKit

enum Constants {
    static let downloadDataNumber = 50
    
    enum Tab {
        static let popularScreenTitle = "Top-50"
        static let popularScreenTabImage = "popcorn"
        static let popularSceenSelectedTabImage = "popcorn.fill"
        
        static let searchScreenTitle = "Поиск"
        static let searchScreenTabImage = "magnifyingglass.circle"
        static let searchSceenSelectedTabImage = "magnifyingglass.circle.fill"
        
        static let watchListScreenTitle = "Посмотрю"
        static let watchListScreenTabImage = "eye"
        static let watchListSceenSelectedTabImage = "eye.fill"
    }
    
    enum ApiRequest {
        static let mainUrl = "https://api.kinopoisk.dev/"
        static let token = "0GFAXYE-3SZ4R0N-MYN7XYM-CBA3V83"
    }
    
    enum Color {
        static let white: UIColor = .white
        static let black: UIColor = .black
        static let orange = UIColor(red: 0.95, green: 0.46, blue: 0, alpha: 1)
    }
    
    enum Offset {
        static let small: CGFloat = 10
        static let medium: CGFloat = 20
        static let large: CGFloat = 40
        
        static let smallCellInset: CGFloat = 10
    }
    
    enum Size {
        static let imageHeight: CGFloat = 170
        static let imageWidth: CGFloat = 120
        
        static let smallImageSize: CGFloat = 50
        static let smallCellHeight: CGFloat = 130
        
        static let cornerRadius: CGFloat = 15
        static let borderWidth: CGFloat = 4
    }
    
    enum FontSize {
        static let titleLabel: CGFloat = 20
        static let textLabel: CGFloat = 17
        static let factLabel: CGFloat = 15
        
        static let large: CGFloat = 25
    }
}
