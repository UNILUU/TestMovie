//
//  TestMovieModel.swift
//  TestMovieTests
//
//  Created by  on 2/28/19.
//

import XCTest
@testable import TestMovie

class TestMovieModel: XCTestCase {
    var movie : Movie!
    var movieModel : MovieModel!
    override func setUp() {
        super.setUp()
        self.movie = Movie(id: 3, title: "Harry Potter", poster_path: "", overview: "Harry Potter is a series of fantasy novels written by British author J. K. Rowling. The novels chronicle the lives of a young wizard, Harry Potter, and his friends Hermione Granger and Ron Weasley, all of whom are students at Hogwarts School of Witchcraft and Wizardry.", vote_average: 3, vote_count: 100, release_date: "2000-1-1")
        self.movieModel = MovieModel(movie: movie)
    }
    
    override func tearDown() {
        movie = nil
        movieModel = nil
    }
    
    func testMessage(){
        XCTAssertEqual(movieModel.movieTitle, "Harry Potter")
        XCTAssertEqual(movieModel.introduction, "Harry Potter is a series of fantasy novels written by British author J. K. Rowling. The novels chronicle the lives of a young wizard, Harry Potter, and his friends Hermione Granger and Ron Weasley, all of whom are students at Hogwarts School of Witchcraft and Wizardry.")
        XCTAssertEqual(movieModel.voteMessage, "Votes ❤️: 100     Score : 3.0")
        XCTAssertEqual(movieModel.releaseMessage, "Release Date: 2000-1-1")
    }
    
    
}
