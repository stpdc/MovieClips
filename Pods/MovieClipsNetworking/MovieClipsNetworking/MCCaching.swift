//
//  MCCaching.swift
//  MovieClips
//
//  Created by Chen Hao on 9/23/18.
//  Copyright © 2018 STPDChen. All rights reserved.
//

import UIKit
import AVFoundation

internal class MCCaching {

    static let shared = MCCaching()
    
    private var videos = [URL: AVPlayerItem]()
    private var images = [URL: UIImage]()
    
    private func video(for url: URL) -> AVPlayerItem? {
        return videos[url]
    }
    
    private func image(for url: URL) -> UIImage? {
        return images[url]
    }
    
    func image(for url: URL, completion: @escaping (UIImage?) -> ()) {
        guard let filePath = getLocalFilePath(url: url) else {
            completion(nil)
            return
        }
        
        if let image = image(for: url) {
            completion(image)
        }
        else if FileManager.default.fileExists(atPath: filePath.path) {
            
            do {
                let data = try Data(contentsOf: filePath)
                let image = UIImage(data: data)
                self.images[url] = image
                completion(image)
            } catch {
                
            }
            
        }
        else {
            getData(from: url) { [weak self] (data, response, error) in
                guard let data = data, let image = UIImage(data: data) else {
                    return
                }
                
                do {
                    try data.write(to: filePath)
                } catch {
                    print(error)
                }
                
                self?.images[url] = image
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
    
    func video(for url: URL, completion: @escaping (AVPlayerItem?) -> ()) {
        guard let filePath = getLocalFilePath(url: url) else {
            completion(nil)
            return
        }
        
        if let video = video(for: url) {
            completion(video)
        }
        else if FileManager.default.fileExists(atPath: filePath.path) {
            let video = AVPlayerItem(url: filePath)
            self.videos[url] = video
            completion(video)

        }
        else {
            getData(from: url) { [weak self] (data, response, error) in
                guard let data = data else {
                    completion(nil)
                    return
                }
                
                do {
                    try data.write(to: filePath)
                } catch {
                    print(error)
                }
                
                let video = AVPlayerItem(url: filePath)
                self?.videos[url] = video
                
                DispatchQueue.main.async {
                    completion(video)
                }
            }
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    private func getLocalFilePath(url: URL) -> URL? {
        let allowed = CharacterSet(charactersIn: "")
        guard let cacheBaseUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first, let fileName = "\(url.pathComponents)".addingPercentEncoding(withAllowedCharacters: allowed) else {
            return nil
        }
        let filePath: URL = cacheBaseUrl.appendingPathComponent(fileName + ".mp4")
        
        return filePath
    }
}
