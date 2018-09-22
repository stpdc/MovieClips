//
//  MCClipsStore.swift
//  MovieClips
//
//  Created by Chen Hao on 9/22/18.
//  Copyright © 2018 STPDChen. All rights reserved.
//

import UIKit

class MCClipsStore {
    
    static let shared = MCClipsStore()
    
    private var networking: MCNetworking
    private var clipModels: [MCClip]
    
    private let sourceUrlString = "http://private-04a55-videoplayer1.apiary-mock.com/pictures"
    
    init() {
        networking = MCNetworking()
        clipModels = []
    }
    
    func load(completion: @escaping (Error?, MCClipsViewModel?) -> ()) {
        fetchClips { (error, clips) in
            if error != nil {
                // TODO: handle error
            }
            
            guard let clips = clips else {
                completion(error, nil)
                return
            }
            
            let viewModel = MCClipsViewModel(with: clips)
            completion(nil, viewModel)
        }
    }

    
    // MARK: Privte
    
    private func fetchClips(completion: @escaping (Error?, [MCClip]?) -> ()) {
        checkCache { [weak self] (error, clips) in
            if error != nil {
                // TODO: handle error
            }
            
            if let clips = clips {
                completion(error, clips)
            } else {
                self?.getClips(completion: completion)
            }
        }
        
    }
    
    private func checkCache(completion: @escaping (Error?, [MCClip]?) -> ()) {
        // TODO: Check Cache
        
        completion(nil, nil)
    }
    
    private func getClips(completion: @escaping (Error?, [MCClip]?) -> ()) {
        guard let url = URL(string: sourceUrlString) else {
            completion(nil, nil)
            return
        }
        
        networking.getClips(url: url) { (error, clips) in
            completion(error, clips)
        }
    }
    
}
