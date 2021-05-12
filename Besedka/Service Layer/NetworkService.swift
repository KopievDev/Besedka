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
    func createUrl(withCode code: String) -> String
}

class NetworkService: NetworkServiceProtocol {
    
    let network: NetworkProtocol
    let cache: ImageCacheProtocol
    let storage: StorageProtocol
    
    init(network: NetworkProtocol = CoreAssembly.shared.network,
         cache: ImageCacheProtocol = CoreAssembly.shared.cacheImage,
         storage: StorageProtocol = CoreAssembly.shared.storage) {
        self.network = network
        self.cache = cache
        self.storage = storage
    }

    func getImagesUrls(withCode code: String, _ completion: @escaping ([String]) -> Void) {
        var urls = [String]()
        network.getCodableData(fromUrlString: createUrl(withCode: code), Response.self) { data in
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
                    return
                }
            } else {
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
    
    func createUrl(withCode code: String) -> String {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "pixabay.com"
        component.path = "/api/"
        component.queryItems = [
            URLQueryItem(name: "key", value: storage.getPrivateData(byKey: "PIXABAY_TOKEN")),
            URLQueryItem(name: "q", value: code),
            URLQueryItem(name: "image_type", value: "photo"),
            URLQueryItem(name: "pretty", value: "true"),
            URLQueryItem(name: "per_page", value: "200")]
        guard let urlString = component.url?.absoluteString else {return "nil"}
        return urlString
    }
    
}
