//
//  FilterViewModelTests.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 25/01/25.
//

import XCTest
@testable import RickAndMorty

final class FilterListViewModelTests: XCTestCase {
    
    var viewModel: FilterListViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = FilterListViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }
    
    func testInitialState() {
        XCTAssertTrue(viewModel.isSortedAscending)
        XCTAssertNil(viewModel.textToSearch)
        XCTAssertNil(viewModel.characterFilters.name)
        XCTAssertNil(viewModel.characterFilters.status)
        XCTAssertNil(viewModel.characterFilters.gender)
    }
    
    func testConfigureWithFilters() {
        let filters = CharacterFilters(name: "Rick", status: .alive, gender: .male)
        viewModel.configure(with: filters)
        
        XCTAssertEqual(viewModel.characterFilters.name, "Rick")
        XCTAssertEqual(viewModel.characterFilters.status, .alive)
        XCTAssertEqual(viewModel.characterFilters.gender, .male)
    }
    
    func testApplyFilters() {
        viewModel.textToSearch = "Morty"
        viewModel.characterFilters.status = .dead
        viewModel.characterFilters.gender = .male
        
        let filters = viewModel.applyFilters()
        
        XCTAssertEqual(filters.name, "Morty")
        XCTAssertEqual(filters.status, .dead)
        XCTAssertEqual(filters.gender, .male)
    }
    
    func testResetFilters() {
        viewModel.textToSearch = "Summer"
        viewModel.characterFilters.status = .unknown
        viewModel.characterFilters.gender = .female
        
        viewModel.resetFilters()
        
        XCTAssertNil(viewModel.textToSearch)
        XCTAssertNil(viewModel.characterFilters.name)
        XCTAssertNil(viewModel.characterFilters.status)
        XCTAssertNil(viewModel.characterFilters.gender)
        XCTAssertTrue(viewModel.isSortedAscending)
    }
    
    func testUpdateFilter() {
        viewModel.updateFilter(forKey: "Status", value: "Alive")
        viewModel.updateFilter(forKey: "Gender", value: "Female")
        
        XCTAssertEqual(viewModel.characterFilters.status, .alive)
        XCTAssertEqual(viewModel.characterFilters.gender, .female)
    }
    
    func testGetSelectedFiltersText() {
        viewModel.characterFilters.status = .alive
        viewModel.characterFilters.gender = .female
        
        let selectedFiltersText = viewModel.getSelectedFiltersText()
        let expectedText = """
        Estado: Alive
        Género: Female
        """
        
        XCTAssertEqual(selectedFiltersText, expectedText)
    }
    
    func testGetSelectedFiltersTextWithEmptyFilters() {
        let selectedFiltersText = viewModel.getSelectedFiltersText()
        XCTAssertTrue(selectedFiltersText.isEmpty)
    }
}

