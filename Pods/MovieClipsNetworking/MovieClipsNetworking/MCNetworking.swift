//
//  MCNetworking.swift
//  MovieClips
//
//  Created by Chen Hao on 9/22/18.
//  Copyright © 2018 STPDChen. All rights reserved.
//

import UIKit

class MCNetworking: NSObject {

    static let shared = MCNetworking()
    
    private let session = URLSession(configuration: .default)
    private var currentTast: URLSessionTask?
    
    func getClips(url: URL , completion: @escaping (Error?, [MCClip]?) -> ()) {
        if currentTast?.state != URLSessionTask.State.completed {
            currentTast?.cancel()
        }
        currentTast = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(error, nil)
                return
            }
            
            guard let data = data else {
                let noDataError = NSError(domain: "MCNetworkingErrorNoData", code: 0, userInfo: nil)
                completion(noDataError, nil)
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let clips = try jsonDecoder.decode([MCClip].self, from: data)
                completion(nil, clips)
            } catch {
                let badDataError = NSError(domain: "MCNetworkingErrorBadData", code: 0, userInfo: nil)
                completion(badDataError, nil)
            }
        }
        
        currentTast?.resume()
    }
}
