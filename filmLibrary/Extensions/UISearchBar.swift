//
//  UISearchBar.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 11.01.2023.
//

import UIKit

extension UISearchBar {
    public var textField: UITextField? {
        if #available(iOS 13, *) {
            return searchTextField
        }
        let subViews = subviews.flatMap { $0.subviews }
        
        return (subViews.filter { $0 is UITextField }).first as? UITextField
    }
    
    func clearBackgroundColor() {
        guard let UISearchBarBackground = NSClassFromString("UISearchBarBackground") else { return }
        
        for view in subviews {
            for subview in view.subviews where subview.isKind(of: UISearchBarBackground) {
                subview.alpha = 0
            }
        }
    }
    
    private var activityIndicator: UIActivityIndicatorView? {
        textField?.leftView?.subviews.compactMap { $0 as? UIActivityIndicatorView }.first
    }
    
    var isLoading: Bool {
        get {
            return activityIndicator != nil
        } set {
            if newValue {
                if activityIndicator == nil {
                    let newActivityIndicator = UIActivityIndicatorView(style: .medium)
                    newActivityIndicator.color = Constants.Color.gray
                    newActivityIndicator.startAnimating()
                    newActivityIndicator.backgroundColor = textField?.backgroundColor ?? Constants.Color.white
                    
                    textField?.leftView?.addSubview(newActivityIndicator)
                    let leftViewSize = textField?.leftView?.frame.size ?? .zero
                    
                    let xOrigin = leftViewSize.width - newActivityIndicator.frame.width / 2
                    let yOrigin = leftViewSize.height / 2
                    let activityCenter = CGPoint(x: xOrigin, y: yOrigin)
                    newActivityIndicator.center = activityCenter
                }
            } else {
                activityIndicator?.removeFromSuperview()
            }
        }
    }
    
    func changePlaceholderColor(_ color: UIColor) {
        guard let UISearchBarTextFieldLabel = NSClassFromString("UISearchBarTextFieldLabel"),
              let field = textField else {
            return
        }
        for subview in field.subviews where subview.isKind(of: UISearchBarTextFieldLabel) {
            guard let label = subview as? UILabel else { return }
            
            label.textColor = color
        }
    }
}
