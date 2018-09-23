//
//  bottomCarouselCell.swift
//  MovieClips
//
//  Created by Chen Hao on 9/22/18.
//  Copyright © 2018 STPDChen. All rights reserved.
//

import UIKit
import MovieClipsNetworking

class bottomCarouselCell: UICollectionViewCell {
    
    private var cellImageView = UIImageView()
    
    private var imageUrl: URL?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .clear

        cellImageView.contentMode = .scaleAspectFit
        cellImageView.clipsToBounds = true
        addSubview(cellImageView)
    }
    
    private func addConstraints() {
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(cellImageView.leftAnchor.constraint(equalTo: leftAnchor))
        addConstraint(cellImageView.rightAnchor.constraint(equalTo: rightAnchor))
        addConstraint(cellImageView.topAnchor.constraint(equalTo: topAnchor))
        addConstraint(cellImageView.bottomAnchor.constraint(equalTo: bottomAnchor))
    }
    
    func config(imageUrl: URL) {
        self.imageUrl = imageUrl
        MovieClipsNetworking.image(for: imageUrl) { [weak self] (image) in
            if self?.imageUrl == imageUrl, let image = image {
                self?.cellImageView.image = image
            }
        }
    }
}
