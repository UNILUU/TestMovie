//
//  TestNetwork.swift
//  TestNetwork
//
//  Created by  on 2/28/19.
//

import XCTest
@testable import TestMovie
class TestNetwork: XCTestCase {
    var listLoader: MovieListLoader!
    var sessionUnderTest: URLSession!
    
    override func setUp() {
        listLoader = MovieListLoader.shared
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "movie", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)

        let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=2a61185ef6a27f400fd92820ad9e8537&query=Harry&page=1")
        let urlResponse = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)

        let sessionMock = URLSessionMock(data: data, response: urlResponse, error: nil)
        listLoader.session = sessionMock
    }
    
    override func tearDown() {
        sessionUnderTest = nil
        super.tearDown()
    }
    
    
    // Fake URLSession with MovieURLSession protocol and stubs
    func test_MovieSearchResults_ParsesData() {
        listLoader.getMovieList(page: 1, searchString: "Harry") { (result) in
            if case let .success(res) = result, let response = res{
                XCTAssertEqual(response.results.count, 3, "Didn't parse 3 movie from fake response")
                XCTAssertEqual(response.page, 1, "Didn't get page 1 from face response")
                XCTAssertEqual(response.total_pages, 2, "Didn't get total page 3 from face response")
            }else{
                XCTFail("Fack response fails to parse")
            }
        }
    }
    
    
}
