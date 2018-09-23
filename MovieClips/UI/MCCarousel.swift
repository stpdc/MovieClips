//
//  MCCarousel.swift
//  MovieClips
//
//  Created by Chen Hao on 9/22/18.
//  Copyright © 2018 STPDChen. All rights reserved.
//

import UIKit

enum MCCarouselContentType {
    case video, image
}

class MCCarousel: UIView {
    
    var collectionView: UICollectionView
    
    var viewModel: MCClipsViewModel? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var contentType: MCCarouselContentType
    
    init(contentType: MCCarouselContentType) {
        self.contentType = contentType
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        super.init(frame: .zero)
        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(collectionView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor))
        addConstraint(collectionView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor))
        addConstraint(collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor))
        addConstraint(collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor))

        switch contentType {
        case .video:
            collectionView.register(topCarouselCell.self, forCellWithReuseIdentifier: "topCarouselCellIdentifier")
        case .image:
            collectionView.register(bottomCarouselCell.self, forCellWithReuseIdentifier: "bottomCarouselCellIdentifier")
        }
        
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var numberOfVisibleCells: Int {
        return 1
    }
    
    var zoomAnimation: Bool {
        return false
    }
    
    var cellSize: CGSize {
        switch contentType {
        case .video:
            return collectionView.frame.size
        case .image:
            return CGSize(width: 100, height: collectionView.frame.size.height * 0.8)
        }
    }
    
    var cellSpacing: CGFloat {
        switch contentType {
        case .video:
            return 0
        case .image:
            return (collectionView.frame.size.width - CGFloat(numberOfVisibleCells) * cellSize.width) / CGFloat(numberOfVisibleCells - 1)
        }
    }
    
    var leftInset: CGFloat {
        switch contentType {
        case .video:
            return 0
        case .image:
            return cellSize.width + cellSpacing
        }
    }
}

extension MCCarousel: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellIdentifier = "topCarouselCellIdentifier"
        switch contentType {
        case .video:
            cellIdentifier = "topCarouselCellIdentifier"
        case .image:
            cellIdentifier = "bottomCarouselCellIdentifier"
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        switch contentType {
        case .video:
            if let cell = cell as? topCarouselCell, let viewModel = viewModel, let videoUrl = viewModel.videoUrl(at: indexPath.row) {
                cell.config(videoUrl: videoUrl)
            }
            break
        case .image:
            break
        }
        
        return cell
    }
}

extension MCCarousel: UICollectionViewDelegate {
    
}

extension MCCarousel: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: leftInset)
    }
}

extension MCCarousel: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        guard let itemCount = viewModel?.count, itemCount > 0 else { return }
        
        let leftInset:CGFloat = self.leftInset
        let spacing:CGFloat = cellSpacing
        let cellWidth:CGFloat = cellSize.width
        let targetOffsetX:CGFloat = targetContentOffset.pointee.x
        
        let firstVisibleCellIndex = Int((targetOffsetX - leftInset) / (cellWidth + spacing))
        
        let calculatedMaxOffset = CGFloat(itemCount) * cellWidth + CGFloat(itemCount - 1) * leftInset + leftInset * 2 - scrollView.frame.width
        let maxOffset = max(calculatedMaxOffset, 0)
        
        if targetContentOffset.pointee.x != maxOffset {
            let firstVisibaleCellLocation = targetContentOffset.pointee.x - CGFloat(firstVisibleCellIndex) * (cellWidth + spacing) - leftInset
            
            if firstVisibaleCellLocation < -cellWidth/2 {
                let offsetForNextItem = CGFloat(firstVisibleCellIndex) * (cellWidth + spacing)
                targetContentOffset.pointee.x = max(offsetForNextItem, 0)
            }
            else if firstVisibaleCellLocation < cellWidth/2 {
                let offsetForNextItem = CGFloat(firstVisibleCellIndex) * (cellWidth + spacing)
                targetContentOffset.pointee.x = min(offsetForNextItem, maxOffset)
            } else {
                let offsetForNextItem = CGFloat(firstVisibleCellIndex + 1) * (cellWidth + spacing)
                targetContentOffset.pointee.x = min(offsetForNextItem, maxOffset)
            }
        }
    }
}

