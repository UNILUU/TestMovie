//
//  DataManager.swift
//  TestMoview
//
//  Created by Xiaolu on 2/25/19.
//

import Foundation
import UIKit

enum Result<T> {
    case success(T?)
    case failure
}

protocol DataMangerDelegate : class{
    func dataDidChange(_ isLoadMore : Bool)
}


class DataManager{
    static let shared = DataManager()
    private let cache = NSCache<NSString, UIImage>()
    private var dict = [String: URLSessionDataTask]()
    private(set) var currentPage : Int
    weak var delegate : DataMangerDelegate?
    private var totalPage : Int?
    private let movieListLoader : MovieListLoader
    private let imageLoader : ImageLoader
    var movieList : [Movie]
    
    var searchString : String? {
        didSet{
            if searchString != oldValue{
                self.loadInitData()
            }
        }
    }
    private init(){
        movieListLoader = MovieListLoader.shared
        imageLoader = ImageLoader.shared
        movieList = [Movie]()
        currentPage = 0
        searchString = "harry potter"
    }
    
    func loadInitData(){
        currentPage = 0
        movieListLoader.getMovieList(page: currentPage + 1, searchString: searchString) { [weak self](result) in
            if case let .success(res) = result, let response = res, let self = self {
                self.movieList = response.results
                self.currentPage = response.page
                self.totalPage = response.total_pages
            }
            DispatchQueue.main.async {
                self?.delegate?.dataDidChange(false)
            }
        }
    }
    
    func getImage(imageURL: String, completion: @escaping (_ result: Result<UIImage> ) -> ()){
        if let image = cache.object(forKey: imageURL as NSString){
            DispatchQueue.main.async {
                completion(Result.success(image))
            }
            return
        }
        imageLoader.downloadImage(imageURL: imageURL) { (result) in
            if case .success(let res) = result, let image = res{
                self.cache.setObject(image, forKey: imageURL as NSString)
                DispatchQueue.main.async {
                    completion(Result.success(image))
                }
            }
        }
    }
    
    func loadMoreMovie(){
        guard let totalPage = totalPage , currentPage < totalPage else {
            return
        }
        movieListLoader.getMovieList(page: currentPage + 1 , searchString: searchString) { [weak self] (result) in
            if case .success(let res) = result, let response = res , let self = self {
                self.movieList += response.results
                self.currentPage = response.page
                self.totalPage = response.total_pages
                DispatchQueue.main.async {
                    self.delegate?.dataDidChange(true)
                }
            }
        }
    }
    
    func cancelTask(at index: Int){
        guard movieList.count > index else { return }
        if let path = movieList[index].poster_path{
            imageLoader.cancelTask(imageURL: path)
        }
    }
    
    func getMovieModel(at index:Int) -> MovieModel{
        assert(movieList.count > index, "movie request not valid")
        return MovieModel(movie : movieList[index])
    }
}
