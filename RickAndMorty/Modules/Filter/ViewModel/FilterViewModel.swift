//
//  FilterViewModel.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 24/01/25.
//

import Foundation

class FilterListViewModel {
    private var keys: [String] = []
    private var valuesDict: [String: Set<String>] = [:]
    private var placeHolderSearch: String?
    
    var isSortedAscending = true
    var textToSearch: String?
    var characterFilters: CharacterFilters = CharacterFilters()
    
    func configure(with filters: CharacterFilters?) {
        if let filters = filters {
            characterFilters = filters
        }
    }
    
    func applyFilters() -> CharacterFilters {
        return CharacterFilters(
            name: textToSearch,
            status: characterFilters.status,
            gender: characterFilters.gender
        )
    }
    
    func resetFilters() {
        characterFilters = CharacterFilters()
        isSortedAscending = true
        textToSearch = nil
    }
    
    func updateFilter(forKey key: String, value: String) {
        switch key {
        case "Status":
            characterFilters.status = Constants.Filters.Status(rawValue: value)
        case "Gender":
            characterFilters.gender = Constants.Filters.Gender(rawValue: value)
        default:
            break
        }
    }
    
    func getSelectedFiltersText() -> String {
        var selectedFilterText = ""
       
        if let status = characterFilters.status {
            if !selectedFilterText.isEmpty { selectedFilterText += "\n" }
            selectedFilterText += "Estado: \(status.rawValue.capitalized)"
        }
        if let gender = characterFilters.gender {
            if !selectedFilterText.isEmpty { selectedFilterText += "\n" }
            selectedFilterText += "Género: \(gender.rawValue.capitalized)"
        }
        
        return selectedFilterText
    }
}

