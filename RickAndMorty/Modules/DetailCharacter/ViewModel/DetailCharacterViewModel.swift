//
//  DetailCharacterViewModel.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 25/01/25.
//

import Foundation
import Combine

final class DetailCharacterViewModel: ObservableObject {
    private let apiService: ApiRetrievalService
    @Published var character: Character?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    var nextPageURL: String? = nil

    init(apiService: ApiRetrievalService) {
        self.apiService = apiService
    }
   
    func loadCharacter(id: Int) {
        guard !isLoading else { return }
        isLoading = true
       
        Task {
            let response = await apiService.getCharacterById(id)
            DispatchQueue.main.async {
                if response.isSuccess,
                   let responseCharacter = response.data {
                    self.character = responseCharacter
                } else {
                    self.errorMessage = response.error?.error ?? Constants.Strings.errorDefault
                }
                self.isLoading = false
            }
        }
    }
}
