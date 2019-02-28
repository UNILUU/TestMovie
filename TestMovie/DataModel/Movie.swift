//
//  Movie.swift
//  TestMoview
//
//  Created by Xiaolu on 2/25/19.
//

import Foundation

struct MovieResponse : Decodable {
    let page : Int
    let total_results : Int
    let total_pages : Int
    let results : [Movie]
}

struct Movie : Decodable {
    let id : Int
    let title : String
    let poster_path : String?
    let overview : String
    let vote_average: Double
    let vote_count : Int
    let release_date : String
}
