//
//  Constants.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 24/01/25.
//

struct Constants {
    struct Filters {
        enum Status: String, CaseIterable, Codable {
            case alive = "Alive"
            case dead = "Dead"
            case unknown = "unknown"
        }
        
        enum Gender: String, CaseIterable, Codable {
            case female = "Female"
            case male = "Male"
            case genderless = "Genderless"
            case unknown = "unknown"
        }
    }
    
    struct Strings {
        static let errorDefault = "Hubo un error, inténtalo de nuevo más tarde"
    }
    
    struct Tags {
        static let tagButtonFilterHome = 10
    }
}
