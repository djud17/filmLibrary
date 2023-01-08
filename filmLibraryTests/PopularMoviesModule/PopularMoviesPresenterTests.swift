//
//  PopularMoviesPresenterTests.swift
//  filmLibraryTests
//
//  Created by Давид Тоноян  on 07.01.2023.
//

import XCTest
@testable import filmLibrary

final class PopularMoviesPresenterTests: XCTestCase {
    private var presenter: PopularMoviesPresenterProtocol?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        presenter = PopularMoviesPresenter(apiClient: ApiClientMock())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLoadData() {
        guard let presenter = presenter else { return }
        
        XCTAssertTrue(presenter.getNumberOfRecords() == 0)
        
        presenter.loadData()
    }
}

private class ApiClientMock: ApiClientProtocol {
    func getPopularMovies(completion: @escaping (Result<PopularMovies, ApiError>) -> Void) {
        let movie = Movie(poster: Poster(previewUrl: ""),
                          rating: Rating(kp: 0, imdb: 0),
                          movieLength: 0,
                          id: 0,
                          type: .movie,
                          name: "",
                          description: "",
                          year: 0,
                          shortDescription: nil,
                          color: nil)
        let topSet = PopularMovies(movies: [movie])
        completion(.success(topSet))
    }
}
