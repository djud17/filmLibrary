//
//  CustomLabel.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 08.01.2023.
//

import UIKit

enum LabelType {
    case title
    case normal
    case fact
}

final class CustomLabel: UILabel {
    private var labelType: LabelType
    
    init(withType labelType: LabelType) {
        self.labelType = labelType
        super.init(frame: .zero)

        textColor = Constants.Color.black
        numberOfLines = 0
        textAlignment = .natural
        
        switch labelType {
        case .title:
            font = .boldSystemFont(ofSize: Constants.FontSize.titleLabel)
        case .normal:
            font = .systemFont(ofSize: Constants.FontSize.textLabel)
        case .fact:
            font = .italicSystemFont(ofSize: Constants.FontSize.factLabel)
            textColor = Constants.Color.white
            textAlignment = .center
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
