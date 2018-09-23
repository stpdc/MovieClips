//
//  MCClipsStore.swift
//  MovieClips
//
//  Created by Chen Hao on 9/22/18.
//  Copyright © 2018 STPDChen. All rights reserved.
//

import UIKit
import AVFoundation
import MovieClipsNetworking

class MCClipsStore {
    
    static let shared = MCClipsStore()
    
    private var clipModels: [MCClip]
    
    private let sourceUrlString = "http://private-04a55-videoplayer1.apiary-mock.com/pictures"
    
    init() {
        clipModels = []
    }
    
    func load(completion: @escaping (Error?, MCClipsViewModel?) -> ()) {
        guard let url = URL(string: sourceUrlString) else {
            completion(nil, nil)
            return
        }
        
        MovieClipsNetworking.clips(url: url) { [weak self] (error, clips) in
            
            guard let clipModels = clips else { return }
            self?.clipModels = clipModels
            
            let viewModel = MCClipsViewModel(with: clipModels)
            completion(nil, viewModel)
        }

    }

    class func image(for url: URL, completion: @escaping (UIImage?) -> ()) {
        MovieClipsNetworking.image(for: url, completion: completion)
    }
    
    class func video(for url: URL, completion: @escaping (AVPlayerItem?) -> ()) {
        MovieClipsNetworking.video(for: url, completion: completion)
    }
}
