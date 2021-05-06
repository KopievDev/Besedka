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
    func createUrlWithCode(_ code: String) -> String
}

class NetworkService: NetworkServiceProtocol {
    
    let network: NetworkProtocol
    let cache: ImageCacheProtocol
    
    init(network: NetworkProtocol = CoreAssembly.shared.network, cache: ImageCacheProtocol = CoreAssembly.shared.cacheImage) {
        self.network = network
        self.cache = cache
    }

    func getImagesUrls(withCode code: String, _ completion: @escaping ([String]) -> Void) {
        var urls = [String]()
        network.getCodableData(fromUrlString: createUrlWithCode(code), Response.self) { data in
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
    
    func createUrlWithCode(_ code: String) -> String {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "pixabay.com"
        component.path = "/api/"
        let queryKey = URLQueryItem(name: "key", value: "21189137-e91aebb15d83ce97f04ecb4d6")
        let queryCodeforSearch = URLQueryItem(name: "q", value: code)
        let queryTypeImage = URLQueryItem(name: "image_type", value: "photo")
        let queryParameters = URLQueryItem(name: "pretty", value: "true")
        let queryCount = URLQueryItem(name: "per_page", value: "200")
        component.queryItems = [queryKey, queryCodeforSearch, queryTypeImage, queryParameters, queryCount]
        guard let urlString = component.url?.absoluteString else {return "nil"}
        print(urlString)
        return urlString
    }
    
}
