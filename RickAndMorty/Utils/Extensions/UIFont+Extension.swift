//
//  UIFont+Extension.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 25/01/25.
//

import UIKit

extension UIFont {
    enum ChalkboardSEType: String {
        case regular = "ChalkboardSE-Regular"
        case bold = "ChalkboardSE-Bold"
        case light = "ChalkboardSE-Light"
    }
    
    static func custom(type: ChalkboardSEType, size: CGFloat) -> UIFont {
        return UIFont(name: type.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
