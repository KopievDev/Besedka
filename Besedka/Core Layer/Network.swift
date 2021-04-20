//
//  Network.swift
//  Besedka
//
//  Created by Ivan Kopiev on 18.04.2021.
//

import UIKit

protocol NetworkProtocol {
    func getCodableData<T: Codable>(_ urlString: String, _ type: T.Type, _ completion: @escaping (T) -> Void)
    func getData(_ urlString: String, _ completion: @escaping (Data) -> Void)
    func getImageCache(_ urlString: String, _ completion: @escaping (UIImage) -> Void)
}

class Network: NetworkProtocol {
    
    let coreService: CoreAssembly = CoreAssembly()
    
    private var currentTask: URLSessionTask?
    var imageUrlString: String?
    
    func getCodableData<T>(_ urlString: String, _ type: T.Type, _ completion: @escaping (T) -> Void) where T: Decodable, T: Encodable {
        createSession(urlString) { data, _ in
            let parser = self.coreService.parser
            guard let dataDecoded = parser.decodeJSON(type: T.self, from: data) else {return}
            DispatchQueue.main.async {
                completion(dataDecoded)
            }
        }
    }
    
    func getData(_ urlString: String, _ completion: @escaping (Data) -> Void) {
        createSession(urlString) { data, _ in
            guard let `data` = data else {return}
            DispatchQueue.global().async {
                completion(data)
            }
        }
    }

    func getImageCache(_ urlString: String, _ completion: @escaping (UIImage) -> Void) {
        
        weak var oldTask = currentTask
        currentTask = nil
        oldTask?.cancel()
        
        self.imageUrlString = urlString
        if let cachedImage = ImageCache.shared.getImage(forKey: urlString) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return
        }
        
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url) { (data, _, error) in
                if let unwrappedError = error {
                    print(unwrappedError)
                    return
                }
                
                if let unwrappedData = data, let downloadedImage = UIImage(data: unwrappedData) {
                    DispatchQueue.global().async {
                        ImageCache.shared.save(image: downloadedImage, forKey: urlString)
                        if self.imageUrlString == urlString {
                            DispatchQueue.main.async {
                                completion(downloadedImage)

                            }
                        }
                    }
                }
                
            }
            currentTask = dataTask
            dataTask.resume()
        }
    }
    
    func createSession(_ urlString: String, _ completion: @escaping (Data?, Error?) -> Void ) {
        
        guard let url = URL(string: urlString) else {return}
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else {
                print("Error task")
                completion(nil, error)
                return
            }
            DispatchQueue.global().async {
                completion(data, nil)
            }
        }
        dataTask.resume()
    }
}
