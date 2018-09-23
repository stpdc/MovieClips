//
//  MCClipsViewModel.swift
//  MovieClips
//
//  Created by Chen Hao on 9/22/18.
//  Copyright © 2018 STPDChen. All rights reserved.
//

import UIKit

class MCClipsViewModel: NSObject {
    
    private var clips: [MCClip]
    
    init(with clips: [MCClip]) {
        self.clips = clips
        super.init()
    }
    
    var count: Int {
        return clips.count
    }
    
    func videoUrl(at index: Int) -> URL? {
        if index < clips.count {
            return clips[index].videoUrl
        } else {
            return nil
        }
    }
    
    func imageUrl(at index: Int) -> URL? {
        if index < clips.count {
            return clips[index].imageUrl
        } else {
            return nil
        }
    }
}
