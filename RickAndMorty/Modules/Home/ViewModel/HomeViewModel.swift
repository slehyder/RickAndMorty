//
//  HomeViewModel.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 24/01/25.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    private let apiService: ApiRetrievalService
    @Published var characters: [Character] = []
    @Published var errorMessage: String?
    @Published var filters: CharacterFilters = CharacterFilters()
    
    var nextPageURL: String? = nil
    @Published var isLoading: Bool = false
    
    init(apiService: ApiRetrievalService) {
        self.apiService = apiService
    }
   
    func loadCharacters(reset: Bool = false) {
        guard !isLoading else { return }
        isLoading = true
        
        if reset {
            characters.removeAll()
            nextPageURL = nil
        }

        Task {
            let response = await apiService.getCharacters(filters: filters, nextPageURL: nextPageURL)
            DispatchQueue.main.async {
                if response.isSuccess {
                    let newCharacters = response.data?.results ?? []
                    self.characters.append(contentsOf: newCharacters)
                    self.nextPageURL = response.data?.info.next?.replacingOccurrences(of: BuildConfig.getURL(for: .BASE_URL), with: "")
                } else {
                    self.errorMessage = response.error?.error ?? Constants.Strings.errorDefault
                }
                self.isLoading = false
            }
        }
    }
}
