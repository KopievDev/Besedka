//
//  NetworkService.swift
//  Besedka
//
//  Created by Ivan Kopiev on 18.04.2021.
//

import UIKit

protocol NetworkServiceProtocol {
    func getImagesUrls(with code: String, _ completion: @escaping ([String]) -> Void)
    func getRandomImage(_ completion: @escaping ([String]) -> Void) 

}

enum UrlColor: String, CaseIterable {
    case blue
    case yellow
    case red
    case pink
    case green
    case orange
    case gray
    case purple
    case ios
    case developer
    case black
    case tech
    case city
}

class NetworkService: NetworkServiceProtocol {
    
    let coreAssembly: CoreAssembly = CoreAssembly()
    
    func getRandomCode() -> String? {
        return UrlColor.allCases.randomElement()?.rawValue
    }
    
    func getRandomImage(_ completion: @escaping ([String]) -> Void) {
        guard let code = getRandomCode() else {return}
        getImagesUrls(with: code) { urls in
            completion(urls)
        }
    }
    
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

    func getImage(_ urlString: String) -> UIImage {
        let network = coreAssembly.network
        var image = UIImage()
        network.getImageCache(urlString) { downloadImage in
            image = downloadImage
        }
        return image
    }
}
