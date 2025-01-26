//
//  Character.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 24/01/25.
//

struct Character: Codable {
    let id: Int
    let name: String
    let status: Constants.Filters.Status?
    let gender: Constants.Filters.Gender?
    let species: String
    let type: String
    let image: String
    let episode: [String]
    let url: String
    let created: String
    let location: Location
    let origin: Origin
}
