//
//  ImageCache.swift
//  Besedka
//
//  Created by Ivan Kopiev on 18.04.2021.
//

import UIKit
protocol ImageCacheProtocol {
    func getImage(forKey key: String) -> UIImage?
    func save(image: UIImage, forKey key: String)
    func removeAllImages()
}

class ImageCache {
    private let config: Config
    private var observer: NSObjectProtocol!
    private lazy var cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.totalCostLimit = config.memoryLimit
        cache.countLimit = config.countLimit
        return cache
    }()
    struct Config {
        let countLimit: Int
        let memoryLimit: Int
        static let defaultConfig = Config(countLimit: 400, memoryLimit: 1024 * 1024 * 200) // 200 MB
    }
    
    init(config: Config = Config.defaultConfig) {
        self.config = config
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification,
                                                          object: nil,
                                                          queue: nil,
                                                          using: { [weak self] _ in
                                                            self?.cache.removeAllObjects()
                                                          })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(observer as Any)
    }
    
}

extension ImageCache: ImageCacheProtocol {
    
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func save(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func removeAllImages() {
        cache.removeAllObjects()
    }
}
