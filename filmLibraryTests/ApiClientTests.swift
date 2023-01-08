//
//  filmLibraryTests.swift
//  filmLibraryTests
//
//  Created by Давид Тоноян  on 05.01.2023.
//

import XCTest
@testable import filmLibrary

final class ApiClientTests: XCTestCase {
    private var apiClient: ApiClientProtocol?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        apiClient = ApiClient()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPresenterLoadData() {
        guard let apiClient else { return }
        
        apiClient.getPopularMovies { result in
            switch result {
            case .success(let popularMovies):
                XCTAssertEqual(popularMovies.movies.count, Constants.downloadDataNumber)
            case .failure:
                break
            }
        }

    }
}
