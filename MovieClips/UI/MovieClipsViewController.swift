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
            loadModel()
        }
    }
    
    private var topView = TopVideoSlideshowView()
    private var bottomView = BottomCarouselView()
    
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
        
        view.addSubview(bottomView)
        
    }
    
    private func addConstraints() {
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    private func loadModel() {
        guard let viewModel = viewModel else {
            resetViews()
            return
        }
        
        // Update Datasoure
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
