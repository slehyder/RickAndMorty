//
//  Untitled.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 25/01/25.
//

import XCTest
import Combine
@testable import RickAndMorty

final class HomeViewModelTests: XCTestCase {
    var mockApiService: MockApiService!
    var viewModel: HomeViewModel!
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockApiService = MockApiService()
        viewModel = HomeViewModel(apiService: mockApiService)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockApiService = nil
        cancellables.removeAll()
        try super.tearDownWithError()
    }
    
    func testLoadCharactersSuccess() throws {
        let mockCharacters = [Character(id: 1, name: "Rick", status: .alive, gender: .male, species: "Human", type: "", image: "", episode: [], url: "", created: "", location: Location(url: "", name: ""))]
        let mockInfo = Info(count: 1, pages: 1, next: nil, prev: nil)
        mockApiService.mockCharactersResponse = CharacterResponse(info: mockInfo, results: mockCharacters)
        
        viewModel.loadCharacters()
        let expectation = XCTestExpectation(description: "Characters loaded")
        
        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                guard !isLoading else { return }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$characters
            .dropFirst()
            .sink { characters in
                XCTAssertEqual(characters.count, 1)
                XCTAssertEqual(characters.first?.name, "Rick")
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertNil(errorMessage, "Error message should be nil")
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadCharactersFailure() throws {
        mockApiService.shouldReturnError = true
        
        viewModel.loadCharacters()
        let expectation = XCTestExpectation(description: "Load characters failed")
        
        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                guard !isLoading else { return }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$characters
            .dropFirst()
            .sink { characters in
                XCTAssertEqual(characters.count, 0)
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertEqual(errorMessage, "An error occurred")
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
