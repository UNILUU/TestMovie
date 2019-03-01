//
//  TestNetwork.swift
//  TestNetwork
//
//  Created by  on 2/28/19.
//

import XCTest
@testable import TestMovie
class TestNetwork: XCTestCase {

    var sessionUnderTest: URLSession!
    
    override func setUp() {
        super.setUp()
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    override func tearDown() {
        sessionUnderTest = nil
        super.tearDown()
    }
    
    // Asynchronous test: success fast, failure slow
    func testMovieSearch() {
        let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=2a61185ef6a27f400fd92820ad9e8537&query=Harry&page=1")
        let promise = expectation(description: "Status code: 200")
        
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
