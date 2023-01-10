//
//  ErrorManager.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 10.01.2023.
//

import UIKit

protocol ErrorManagerProtocol {
    func createErrorMessage(message: String) -> UIAlertController
}

final class ErrorManager: ErrorManagerProtocol {
    static let shared = ErrorManager()
    
    func createErrorMessage(message: String) -> UIAlertController {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okButton)
        
        return alertController
    }
}
