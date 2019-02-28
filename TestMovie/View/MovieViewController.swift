//
//  MovieViewController.swift
//  TestMovie
//
//  Created by  on 2/27/19.
//

import UIKit

class MovieViewController: UIViewController {
    let movieImageView : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "Image")
        image.widthAnchor.constraint(equalToConstant: 254).isActive = true
        image.heightAnchor.constraint(equalToConstant: 382).isActive = true
        image.clipsToBounds = true
        return image
    }()
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let voteLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let dateLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let detailLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //    let scrollView: UIScrollView = {
    //        let v = UIScrollView()
    //        v.translatesAutoresizingMaskIntoConstraints = false
    //        v.backgroundColor = UIColor.white
    //        return v
    //    }()
    
    let movie : Movie
    let manager : DataManager
    init(_ movie: Movie, _ dataManger: DataManager) {
        self.movie = movie
        self.manager = dataManger
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = []
        //        view.addSubview(scrollView)
        //        NSLayoutConstraint.activate([
        //            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
        //            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
        //            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
        //            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        //        ])
        
        let textStackView = UIStackView(arrangedSubviews: [titleLabel, voteLabel, dateLabel])
        textStackView.axis = .vertical
        textStackView.alignment = .center
        textStackView.distribution = .fill
        textStackView.spacing = 8
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textStackView)
        view.addSubview(movieImageView)
        view.addSubview(detailLabel)
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            movieImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 8),
            textStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            textStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            movieImageView.bottomAnchor.constraint(equalTo: textStackView.topAnchor, constant: -20),
            detailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            detailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            detailLabel.topAnchor.constraint(equalTo: textStackView.bottomAnchor, constant: 10),
            ])
        setUp()
    }
    
    private func setUp(){
        titleLabel.text = movie.title
        detailLabel.text = movie.overview
        voteLabel.text = String("Vote ❤️: \(movie.vote_count)")
        dateLabel.text = String("Release: \(movie.release_date)")
        if let imagepath = movie.poster_path{
            manager.getImage(imageString: imagepath) { [weak self](result) in
                if case .success(let image) = result {
                    self?.movieImageView.image = image
                }
            }
        }
        
    }
    
    
}
