//
//  UITableview+Extension.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 25/01/25.
//

import UIKit

// MARK: - UITableView
extension UITableView {
    
    //This method allow to register cells ONLY of the
    //.xib and the cell class has the same name
    
    func registerCell(named: String) {
        let identifier = named
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
    //In order to register a cell, its identifier must be the same as className
    public func register<T: UITableViewCell>(cell: T.Type) {
        register (UINib(nibName: "\(T.self)", bundle: nil), forCellReuseIdentifier: "\(T.self)")
    }
    
    //In order to register a headerFooterView, its identifier must be the same as className
    public func register<T: UITableViewHeaderFooterView> (headerFooterView: T.Type) {
       register (UINib(nibName: "\(T.self)", bundle: nil), forHeaderFooterViewReuseIdentifier: "\(T.self)")
    }
    
    public func registerFromClass<T: UITableViewHeaderFooterView> (headerFooterView: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: "\(T.self)")
    }
        
    public func dequeueReusableCell<T: UITableViewCell>(for type: T.Type, for indexPath: IndexPath) -> T {
       guard let cell = dequeueReusableCell(withIdentifier: "\(T.self)", for: indexPath) as? T else {
           fatalError("Failed to dequeue cell.")
       }
       return cell
    }
        
    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView> (for type: T.Type) ->T {
       guard let view = dequeueReusableHeaderFooterView (withIdentifier: "\(T.self)") as? T else {
           fatalError("Failed to dequeue footer view.")
       }
        return view
    }
}
