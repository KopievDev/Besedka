//
//  FileGCD.swift
//  Besedka
//
//  Created by Ivan Kopiev on 17.03.2021.
//

import UIKit

protocol FileManagerProtocol {
    func filePath(forKey key: String) -> URL?
    func saveImageToFile(_ image: UIImage?,
                         byName name: String,
                         completion: @escaping () -> Void)
    func getImageFromFile(name: String,
                          runQueue: DispatchQueue,
                          completionQueue: DispatchQueue,
                          completion: @escaping (UIImage?) -> Void)
    func deleteFile(name: String)
    func saveUser(_ user: UserProfile?, completion: @escaping ((Error?) -> Void))
    func getUser(_ completion: @escaping (UserProfile?) -> Void)
    func saveTheme(name theme: String?)
    func getTheme(_ completion: @escaping (String?) -> Void)
    
    func getData<T: Decodable>(type: T.Type, from file: String, _ completion: @escaping (T?) -> Void)

}

class FileManagerGCD: FileManagerProtocol {
    
    let queue = DispatchQueue.global(qos: .utility)
    let main = DispatchQueue.main
    let coreAssembly = CoreAssembly()
    let parser: ParserServiceProtocol
    let coreParser: ParserProtocol = CoreAssembly().parser
    let storage: StorageProtocol
    
    init(parser: ParserServiceProtocol = ServiceAssembly().parser, storage: StorageProtocol = CoreAssembly().storage) {
        self.parser = parser
        self.storage = storage
    }
    public func saveImageToFile(_ image: UIImage?,
                                byName name: String,
                                completion: @escaping () -> Void) {
        queue.async {
            guard let pngData = image?.pngData(),
                  let filePath = self.filePath(forKey: name) else { return }
            try? pngData.write(to: filePath, options: .atomic)
            self.main.async {completion()}
        }
    }
    
    public func deleteFile(name: String) {
        queue.async {
            let filePath = self.storage.stringPath() + name
            self.storage.removeFile(atPath: filePath)
        }
    }
    
    public func getImageFromFile(name: String,
                                 runQueue: DispatchQueue,
                                 completionQueue: DispatchQueue,
                                 completion: @escaping (UIImage?) -> Void) {
        runQueue.async {
            guard let filePath = self.filePath(forKey: name),
                  let fileData = self.storage.contents(atPath: filePath.path),
                  let image = UIImage(data: fileData ) else {return}
            completionQueue.async {completion(image)}
        }
    }
    
    public func saveUser(_ user: UserProfile?, completion: @escaping ((Error?) -> Void)) {
        queue.async {
            guard let user = user,
                  let filePath = self.filePath(forKey: "UserProfile.json") else { return }
            do {
                try self.parser.toData(from: user).write(to: filePath)
                self.main.async {completion(nil)}
            } catch let error {
                self.main.async {completion(error)}
                print(error, "ERROR SAVED USER")
            }
        }
    }
    
    public func getUser(_ completion: @escaping (UserProfile?) -> Void) {
        queue.async {
            guard let filePath = self.filePath(forKey: "UserProfile.json"),
                  let jsonDataFile = try? Data(contentsOf: filePath),
                  let user = self.parser.parse(json: jsonDataFile) else {
                print("ERROR with get user from file")
                return
            }
            self.main.async {completion(user)}
        }
    }
    
    public func getData<T: Decodable>(type: T.Type, from file: String, _ completion: @escaping (T?) -> Void) {
        queue.async {
            guard let filePath = self.filePath(forKey: file),
                  let jsonData = try? Data(contentsOf: filePath),
                  let data = self.coreParser.decodeJSON(type: T.self, from: jsonData) else {return}
            self.main.async {completion(data)}
        }
    }
    
    public func saveTheme(name theme: String?) {
        queue.async {
            guard let name = theme,
                  let filePath = self.filePath(forKey: "Theme.plist")  else {return}
            let dict = NSMutableDictionary()
            dict.setValue(name, forKey: "name")
            dict.write(to: filePath, atomically: true)
        }
    }
    
    public func getTheme(_ completion: @escaping (String?) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let filePath = self.filePath(forKey: "Theme.plist"),
                  let object = NSDictionary(contentsOf: filePath),
                  let theme = object.value(forKey: "name") as? String else {
                self.main.async {completion("Day")}
                return
            }
            self.main.async {completion(theme)}
        }
    }
    
    internal func filePath(forKey key: String) -> URL? {
        return storage.urlPath()?.appendingPathComponent(key)
    }
    
}
