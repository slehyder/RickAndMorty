//
//  String+Extension.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 24/01/25.
//

import UIKit

extension String {
    
    /// Returns true iff a String is empty or composed of spaces only.
    public func isBlank() -> Bool {
        
        let trimmed = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmed.isEmpty
    }
}
