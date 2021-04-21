//
//  Network.swift
//  Besedka
//
//  Created by Ivan Kopiev on 18.04.2021.
//

import UIKit

protocol NetworkProtocol {
    func getCodableData<T: Codable>(_ urlString: String, _ type: T.Type, _ completion: @escaping (T) -> Void)
    func getDataFrom(_ urlString: String, _ completion: @escaping (Data) -> Void)
}

class Network: NetworkProtocol {
    
    let coreService: CoreAssembly = CoreAssembly()
    // Получение кодируемых данных
    func getCodableData<T>(_ urlString: String, _ type: T.Type, _ completion: @escaping (T) -> Void) where T: Decodable, T: Encodable {
        createSession(urlString) { data, _ in
            let parser = self.coreService.parser
            guard let dataDecoded = parser.decodeJSON(type: T.self, from: data) else {return}
            DispatchQueue.main.async {
                completion(dataDecoded)
            }
        }
    }
    // Получение данных по URL
    func getDataFrom(_ urlString: String, _ completion: @escaping (Data) -> Void) {
        createSession(urlString) { data, _ in
            guard let `data` = data else {return}
            DispatchQueue.global().async {
                completion(data)
            }
        }
    }
    // Создание сетевой сессии
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
