//
//  MovieDataModel.swift
//  TestMovie
//
//  Created by  on 2/28/19.
//

import Foundation


struct MovieModel {
    let movie : Movie
    init(movie : Movie){
        self.movie = movie
    }
    
    var introduction: String {
        get {
            return movie.overview
        }
    }
    var movieTitle : String {
        get {
            return movie.title
        }
    }
    var voteMessage : String {
        get {
            return String("Votes ❤️: \(movie.vote_count)     Score : \(movie.vote_average)")
        }
    }
    var releaseMessage : String {
        get {
            return String("Release Date: \(movie.release_date)")
        }
    }
    var imageURL : String? {
        get {
            return movie.poster_path
        }
    }
    
}
