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
    
    
}
