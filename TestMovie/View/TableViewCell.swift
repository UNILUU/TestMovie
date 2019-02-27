//
//  TableViewCell.swift
//  TestMoview
//
//  Created by  on 2/25/19.
//

import UIKit

class TableViewCell: UITableViewCell {
    let movieImageView : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "Image")
        image.widthAnchor.constraint(equalToConstant: 127).isActive = true
        image.heightAnchor.constraint(equalToConstant: 191).isActive = true
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
    let detailLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(red: 232/255, green: 245/255, blue: 253/255, alpha: 0.8)
        
        let textStackView = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        textStackView.axis = .vertical
        textStackView.alignment = .fill
        textStackView.distribution = .fillEqually
        textStackView.spacing = 5
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(textStackView)
        self.contentView.addSubview(movieImageView)
        
        NSLayoutConstraint.activate([
            
            movieImageView.trailingAnchor.constraint(equalTo: textStackView.leadingAnchor, constant: -8),
            movieImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            movieImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            movieImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            textStackView.centerYAnchor.constraint(equalTo: movieImageView.centerYAnchor),
            textStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.image = UIImage(named: "Image")
    }
    
}
