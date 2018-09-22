//
//  MCClip.swift
//  MovieClips
//
//  Created by Chen Hao on 9/22/18.
//  Copyright © 2018 STPDChen. All rights reserved.
//

import UIKit

class MCClip: Codable {

    var id: Int
    var imageUrl: URL
    var videoUrl: URL
    
    init(id: Int, imageUrl: URL, videoUrl: URL) {
        self.id = id
        self.imageUrl = imageUrl
        self.videoUrl = videoUrl
    }
    
}
