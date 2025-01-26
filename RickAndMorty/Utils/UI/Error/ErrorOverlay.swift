//
//  ErrorOverlay.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 25/01/25.
//

import UIKit

struct ErrorOverlay {
    
    static func showErrorOverlay(in view: UIView, message: String = Constants.Strings.errorDefault) {
        if let existingErrorView = view.viewWithTag(202) as? ErrorView {
            existingErrorView.setMessage(message)
            return
        }
        
        let errorView = ErrorView()
        errorView.tag = 202
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.setMessage(message)
        
        view.addSubview(errorView)
        
        NSLayoutConstraint.activate([
            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            errorView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
        
        errorView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            errorView.alpha = 1
        }
    }
    
    static func hideErrorOverlay(from view: UIView) {
        guard let errorView = view.viewWithTag(202) as? ErrorView else {
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            errorView.alpha = 0
        }, completion: { _ in
            errorView.removeFromSuperview()
        })
    }
}
