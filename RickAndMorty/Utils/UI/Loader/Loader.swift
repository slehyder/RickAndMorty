//
//  Loader.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 24/01/25.
//

import UIKit

struct Loader {
    
    static func showLoader(in view: UIView) {
        if view.viewWithTag(101) is LoaderView {
            return
        }
        
        let loaderView = LoaderView()
        loaderView.tag = 101
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loaderView)
        
        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loaderView.widthAnchor.constraint(equalToConstant: 100),
            loaderView.heightAnchor.constraint(equalToConstant: 100)
        ])
        loaderView.startAnimating()
    }
    
    static func hideLoader(from view: UIView) {
        if let loaderView = view.viewWithTag(101) as? LoaderView {
            loaderView.stopAnimating()
            loaderView.removeFromSuperview()
        }
    }
}
