//
//  ApiService.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 24/01/25.
//

import Foundation

protocol ApiRetrievalService {
    func getCharacters(filters: CharacterFilters, nextPageURL: String?) async -> NetworkResource<CharacterResponse>
    func getCharacterById(_ id: Int) async -> NetworkResource<Character?>
}

class ApiService: ApiRetrievalService {
    
    func getCharacters(filters: CharacterFilters, nextPageURL: String?) async -> NetworkResource<CharacterResponse> {
        do {
            let path: String
            if let nextPageURL = nextPageURL {
                path = nextPageURL
            } else {
                let queryParameters = filters.toQueryParameters()
                path = "/character/" + (queryParameters.isEmpty ? "" : "?\(queryParameters)")
            }
            
            let responseData = try await ServiceRequest.makeRequest(path: path, method: .get) as CharacterResponse
            return NetworkResource(successData: responseData)
        } catch {
            return NetworkResource(error: MainErrorResponse.cathError(error: error))
        }
    }
    
    func getCharacterById(_ id: Int) async -> NetworkResource<Character?> {
        do {
            let path = "/character/\(id)"
            let responseData = try await ServiceRequest.makeRequest(path: path, method: .get, useCache: true) as Character
            return NetworkResource(successData: responseData)
        } catch {
            return NetworkResource(error: MainErrorResponse.cathError(error: error))
        }
    }
}
