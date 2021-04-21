//
//  NetworkService.swift
//  Besedka
//
//  Created by Ivan Kopiev on 18.04.2021.
//

import UIKit

protocol NetworkServiceProtocol {
    func getImagesUrls(with code: String, _ completion: @escaping ([String]) -> Void)
    func getImage(from urlString: String, _ completion: @escaping (UIImage) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    let coreAssembly: CoreAssembly = CoreAssembly()
    lazy var network: NetworkProtocol = self.coreAssembly.network

    func getImagesUrls(with code: String, _ completion: @escaping ([String]) -> Void) {
        let url = "https://pixabay.com/api/?key=21189137-e91aebb15d83ce97f04ecb4d6&q=\(code)&image_type=photo&pretty=true&per_page=200"
        let network = coreAssembly.network
        var urls = [String]()
        network.getCodableData(url, Response.self) { data in
            data.hits?.forEach { avatar in
                guard let url = avatar.imageURL else {return}
                urls.append(url)
            }
            DispatchQueue.main.async {completion(urls)}
        }
    }
    
    func getImage(from urlString: String, _ completion: @escaping (UIImage) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            if let cachedImage = self.imageFromCache(urlString) {
                DispatchQueue.main.async {
                    completion(cachedImage)
                    print("getting image from cache")
                    return
                }
            } else {
                print("getting image from internet")
                self.network.getDataFrom(urlString) { data in
                    guard let image = UIImage(data: data) else {return}
                    ImageCache.shared.save(image: image, forKey: urlString)
                    DispatchQueue.main.async {
                        completion(image)
                        return
                    }
                }
            }
        }
    }
    
    func imageFromCache(_ url: String) -> UIImage? {
        return ImageCache.shared.getImage(forKey: url)
    }
    
}
