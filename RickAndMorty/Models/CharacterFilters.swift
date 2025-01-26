//
//  CharacterFilters.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 24/01/25.
//

struct CharacterFilters {
    var name: String?
    var status: Constants.Filters.Status?
    var gender: Constants.Filters.Gender?

    func toQueryParameters() -> String {
        var parameters: [String] = []

        if let name = name, !name.isEmpty {
            parameters.append("name=\(name)")
        }
        if let status = status, !status.rawValue.isEmpty {
            parameters.append("status=\(status)")
        }
        if let gender = gender, !gender.rawValue.isEmpty {
            parameters.append("gender=\(gender)")
        }

        return parameters.joined(separator: "&")
    }
}
