//
//  NetworkService.swift
//  Besedka
//
//  Created by Ivan Kopiev on 18.04.2021.
//

import UIKit

protocol NetworkServiceProtocol {
    func getImagesUrls(withCode code: String, _ completion: @escaping ([String]) -> Void)
    func getImage(fromUrlString url: String, _ completion: @escaping (UIImage) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    let coreAssembly: CoreAssembly = CoreAssembly()
    lazy var network: NetworkProtocol = self.coreAssembly.network
    lazy var cache = coreAssembly.cacheImage

    func getImagesUrls(withCode code: String, _ completion: @escaping ([String]) -> Void) {
        let url = "https://pixabay.com/api/?key=21189137-e91aebb15d83ce97f04ecb4d6&q=\(code)&image_type=photo&pretty=true&per_page=200"
        let network = coreAssembly.network
        var urls = [String]()
        network.getCodableData(fromUrlString: url, Response.self) { data in
            data.hits?.forEach { avatar in
                guard let url = avatar.imageURL else {return}
                urls.append(url)
            }
            DispatchQueue.main.async {completion(urls)}
        }
    }
    
    func getImage(fromUrlString urlString: String, _ completion: @escaping (UIImage) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            if let cachedImage = self.cache.getImage(forKey: urlString) {
                DispatchQueue.main.async {
                    completion(cachedImage)
                    print("getting image from cache")
                    return
                }
            } else {
                print("getting image from internet")
                self.network.getDataFrom(fromUrlString: urlString) { data in
                    guard let image = UIImage(data: data) else {return}
                    self.cache.save(image: image, forKey: urlString)
                    DispatchQueue.main.async {
                        completion(image)
                        return
                    }
                }
            }
        }
    }
    
}
