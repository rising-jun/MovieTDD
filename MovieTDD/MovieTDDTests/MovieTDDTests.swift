//
//  MovieTDDTests.swift
//  MovieTDDTests
//
//  Created by 김동준 on 2022/05/27.
//

import XCTest
@testable import MovieTDD

class MovieTDDTests: XCTestCase {

    var movieService: MovieService?
    
    override func setUpWithError() throws {
        movieService = MovieService()
    }

    func testGetMovieData() {
        let expectation = XCTestExpectation(description: "Loading")
        
        guard let jsonPath = Bundle.main.path(forResource: "MockMovieData", ofType: "json") else { return }
        guard let jsonString = try? String(contentsOfFile: jsonPath) else { return }
        guard let mockData = jsonString.data(using: .utf8) else { return }
        guard let expected = try? JSONDecoder().decode(MovieItems.self, from: mockData) else { return }
        
        MovieMockProtocol.loadingHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, mockData, nil)
        }
        
        movieService?.requestMovieInfo(api: MovieAPI.searchMovies(title: "IronMan"), completionHandler: { (result: Result<MovieItems, NetworkError>) in
            switch result {
            case .success(let movieItems):
                XCTAssertEqual(movieItems, expected)
            case .failure(let error):
                XCTAssertThrowsError(error)
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)
    }
    
    override func tearDownWithError() throws {
        movieService = nil
    }
}
