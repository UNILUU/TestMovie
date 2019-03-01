//
//  ImageLoader.swift
//  TestMovie
//
//  Created by  on 3/1/19.
//

import Foundation
import UIKit
typealias resCompletion = (Result<UIImage>) -> ()

class ImageLoader{
    var session : MovieURLSession = URLSession.shared
    static let shared = ImageLoader()
    var dict = [String: URLSessionDataTask]()
    
    //completion dictionary is used for preventing duplicate downloading task.
    //Will temperatry store following complation blocks if first task is not yet finised.
    var completionDict = [String : [resCompletion]]()
    
    private init(){
    }
    
    func downloadImage(imageURL: String, completion: @escaping (_ result: Result<UIImage>) -> ()){
        //save completion if image is already downloading
        if let _ = completionDict[imageURL] {
            completionDict[imageURL]?.append(completion)
            return
        }
        
        let urlString = "https://image.tmdb.org/t/p/w600_and_h900_bestv2\(imageURL)"
        guard let url = URL(string: urlString) else {
            completion(Result.failure)
            return
        }
        let task = session.dataTask(with: url) {[weak self] (data, _, error) in
            guard error == nil, let data = data, let imagedata = UIImage(data: data) else {
                if let completionList = self?.completionDict[imageURL] {
                    //perform all saved completion
                    for comp in completionList {
                        comp(Result.failure)
                    }
                }
                self?.completionDict[imageURL] = nil
                self?.dict[imageURL] = nil
                return
            }
            if let completionList = self?.completionDict[imageURL] {
                //perform all saved completion
                for comp in completionList {
                    comp(Result.success(imagedata))
                }
                self?.completionDict[imageURL] = nil
                self?.dict[imageURL] = nil
            }
        }
        dict[imageURL] = task
        completionDict[imageURL, default: []].append(completion)
        task.resume()
    }
    
    
    func cancelTask(imageURL : String){
        if let task = dict[imageURL]{
            task.cancel()
            dict[imageURL] = nil
            completionDict[imageURL] = nil
        }
    }
}
