//
//  MockApiService.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 25/01/25.
//

import Foundation

class MockApiService: ApiRetrievalService {
    var mockCharactersResponse: CharacterResponse?
    var shouldReturnError: Bool = false
    
    func getCharacters(filters: CharacterFilters, nextPageURL: String?) async -> NetworkResource<CharacterResponse> {
        if shouldReturnError {
            return NetworkResource(error: MainErrorResponse(error: "An error occurred"))
        } else {
            guard let response = mockCharactersResponse else {
                return NetworkResource(error: MainErrorResponse(error: "No mock response provided"))
            }
            return NetworkResource(successData: response)
        }
    }

    
    func getCharacterById(_ id: Int) async -> NetworkResource<Character?> {
        if shouldReturnError {
            return NetworkResource(error: MainErrorResponse(error: "An error occurred"))
        } else {
            let mockCharacter = Character(id: id, name: "Mock Character", status: .alive, gender: .male, species: "Human", type: "", image: "", episode: [], url: "", created: "", location: Location(url: "", name: ""), origin: Origin(url: nil, name: nil))
            return NetworkResource(successData: mockCharacter)
        }
    }
}
