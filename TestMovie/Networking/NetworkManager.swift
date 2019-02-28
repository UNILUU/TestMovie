//
//  NetworkManager.swift
//  TestMovie
//
//  Created by Xiaolu on 2/25/19.
//

import Foundation
import UIKit
typealias resCompletion = (Result<UIImage>) -> ()

class NetworkManager {
    private let session = URLSession.shared
    static let shared = NetworkManager()
    var dict = [String: URLSessionDataTask]()
    var completionDict = [String : [resCompletion]]()
    
    private init(){
    }
    
    func getMovieList(page: Int, searchString: String?, compeltion: @escaping(Result<MovieResponse>) -> Void){
        let search = searchString?.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) ?? ""
        let urlPath = "https://api.themoviedb.org/3/search/movie?api_key=2a61185ef6a27f400fd92820ad9e8537&query=\(search)&page=\(page)"
        guard let url = URL(string: urlPath) else {
            compeltion(Result.failure)
            return
        }
        let task = session.dataTask(with: url) { (data, _, error) in
            guard error == nil else { return }
            if let data = data, let movieResponse = try? JSONDecoder().decode(MovieResponse.self, from: data) {
                compeltion(Result.success(movieResponse))
            } else {
                compeltion(Result.failure)
            }
        }
        task.resume()
    }

    
    func downloadImage(imageString: String, completion: @escaping (_ result: Result<UIImage>) -> ()){
        //save completion if image is already downloading
        if let _ = completionDict[imageString] {
            completionDict[imageString]?.append(completion)
            return
        }
        
        let urlString = "https://image.tmdb.org/t/p/w600_and_h900_bestv2\(imageString)"
        guard let url = URL(string: urlString) else {
            completion(Result.failure)
            return
        }
        let task = session.dataTask(with: url) {[weak self] (data, _, error) in
            guard error == nil, let data = data, let imagedata = UIImage(data: data) else {
                if let completionList = self?.completionDict[imageString] {
                    //perform all saved completion
                    for comp in completionList {
                        comp(Result.failure)
                    }
                }
                return
            }
            if let completionList = self?.completionDict[imageString] {
                //perform all saved completion
                for comp in completionList {
                    comp(Result.success(imagedata))
                }
            }
        }
        dict[imageString] = task
        completionDict[imageString, default: []].append(completion)
        task.resume()
    }
    
    func cancelTask(imageString : String){
        if let task = dict[imageString]{
            task.cancel()
            dict[imageString] = nil
            completionDict[imageString] = nil
        }
    }
}
