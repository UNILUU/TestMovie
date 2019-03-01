//
//  MovieViewController.swift
//  TestMovie
//
//  Created by Xiaolu on 2/27/19.
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
    let introLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    let movie : MovieModel
    let manager : DataManager
    
    init(_ movie: MovieModel, _ dataManger: DataManager) {
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
        
        //set up scroll view
        view.addSubview(scrollView)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            ])
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])
        
        
        // set up text view and image
        let textStackView = UIStackView(arrangedSubviews: [titleLabel, voteLabel, dateLabel])
        textStackView.axis = .vertical
        textStackView.alignment = .center
        textStackView.distribution = .fill
        textStackView.spacing = 8
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textStackView)
        contentView.addSubview(movieImageView)
        contentView.addSubview(introLabel)
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            movieImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 8),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            textStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            movieImageView.bottomAnchor.constraint(equalTo: textStackView.topAnchor, constant: -20),
            introLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            introLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            introLabel.topAnchor.constraint(equalTo: textStackView.bottomAnchor, constant: 10),
            contentView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 1),
            introLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            ])
        
        setUpView()
    }
    
    private func setUpView(){
        titleLabel.text = movie.movieTitle
        introLabel.text = movie.introduction
        voteLabel.text = movie.voteMessage
        dateLabel.text = movie.releaseMessage
        if let imagepath = movie.imageURL{
            manager.getImage(imageURL: imagepath) { [weak self](result) in
                if case .success(let image) = result {
                    self?.movieImageView.image = image
                }
            }
        }
    }
}
