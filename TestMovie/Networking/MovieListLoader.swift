//
//  MovieListLoader.swift
//  TestMovie
//
//  Created by  on 3/1/19.
//

import Foundation

class MovieListLoader {
    var session : MovieURLSession = URLSession.shared
    static let shared = MovieListLoader()
    
    private init(){
    }
    
    func getMovieList(page: Int, searchString: String?, compeltion: @escaping(Result<GetListResponse>) -> Void){
        let search = searchString?.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) ?? ""
        let urlPath = "https://api.themoviedb.org/3/search/movie?api_key=2a61185ef6a27f400fd92820ad9e8537&query=\(search)&page=\(page)"
        guard let url = URL(string: urlPath) else {
            compeltion(Result.failure)
            return
        }
        let task = session.dataTask(with: url) { (data, _, error) in
            guard error == nil else { return }
            if let data = data, let movieResponse = try? JSONDecoder().decode(GetListResponse.self, from: data) {
                compeltion(Result.success(movieResponse))
            } else {
                compeltion(Result.failure)
            }
        }
        task.resume()
    }

}
