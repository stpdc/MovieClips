//
//  MovieClipsViewController.swift
//  MovieClips
//
//  Created by Chen Hao on 9/22/18.
//  Copyright © 2018 STPDChen. All rights reserved.
//

import UIKit

class MovieClipsViewController: UIViewController {

    var viewModel: MCClipsViewModel? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.loadModel()
            }
        }
    }
    
    private var topView = TopVideoSlideshowView(contentType: .video)
    private var bottomView = BottomCarouselView(contentType: .image)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Movies"
        view.backgroundColor = .white
        
        setupViews()
        addConstraints()
        
        fetchClips()
    }
    
    private func fetchClips() {
        MCClipsStore.shared.load { [weak self] (error, viewModel) in
            self?.viewModel = viewModel
        }
    }
    
    private func setupViews() {
        view.addSubview(topView)
        topView.delegate = self
        
        view.addSubview(bottomView)
        bottomView.delegate = self
    }
    
    private func addConstraints() {
        topView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8))
        view.addConstraint(topView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        view.addConstraint(topView.widthAnchor.constraint(equalTo: topView.heightAnchor))
        view.addConstraint(topView.leftAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leftAnchor))
        
        let betweenConstant = topView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -8)
        betweenConstant.priority = .defaultLow
        view.addConstraint(betweenConstant)
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        view.addConstraint(bottomView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor))
        view.addConstraint(bottomView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        view.addConstraint(bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8))
        view.addConstraint(bottomView.heightAnchor.constraint(equalToConstant: 200))
        
    }
    
    private func loadModel() {
        guard let viewModel = viewModel else {
            resetViews()
            return
        }
        
        topView.viewModel = viewModel
        bottomView.viewModel = viewModel        
    }
    
    private func resetViews() {
        
    }
}

extension MovieClipsViewController {
    
    internal class TopVideoSlideshowView: MCCarousel {
        
        override var numberOfVisibleCells: Int {
            return 1
        }
        
        override var zoomAnimation: Bool {
            return false
        }
        
    }
    
    internal class BottomCarouselView: MCCarousel {
        
        override var numberOfVisibleCells: Int {
            return 3
        }
        
        override var zoomAnimation: Bool {
            return true
        }
        
    }
}

extension MovieClipsViewController: MCCarouselDelegate {
    
    func willScrollTo(from carousel: MCCarousel, index: Int) {
        if carousel == topView {
            bottomView.scrollTo(index: index)
        }
        if carousel == bottomView {
            topView.scrollTo(index: index)
        }
    }
}
