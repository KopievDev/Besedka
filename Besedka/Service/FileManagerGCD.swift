//
//  FileGCD.swift
//  Besedka
//
//  Created by Ivan Kopiev on 17.03.2021.
//

import UIKit

class FileManagerGCD {
    
    let queue = DispatchQueue.global(qos: .utility)
    let main = DispatchQueue.main
    
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
        let fileNameToDelete = name
        var filePath = ""
        queue.async {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentDirectory = paths[0]
            filePath = documentDirectory.appendingFormat("/" + fileNameToDelete)
            do {
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {
                    try fileManager.removeItem(atPath: filePath)
                } else {
                    print("File does not exist")
                }
            } catch let error as NSError {
                print("An error took place: \(error)")
            }
        }
    }
    
    public func getImageFromFile(name: String,
                                 runQueue: DispatchQueue,
                                 completionQueue: DispatchQueue,
                                 completion: @escaping (UIImage?) -> Void) {
        runQueue.async {
            guard let filePath = self.filePath(forKey: name) else {return}
            guard let fileData = FileManager.default.contents(atPath: filePath.path) else {return}
            guard let image = UIImage(data: fileData) else {return}
            completionQueue.async {completion(image)}
        }
    }
    
    public func saveUser(_ user: UserProfileModel?, completion: @escaping ((Error?) -> Void)) {
        queue.async {
            guard let user = user,
                  let filePath = self.filePath(forKey: "UserProfile.json") else { return }
            do {
                try JSONEncoder().encode(user).write(to: filePath)
                OperationQueue.main.addOperation {completion(nil)}
            } catch let error {
                OperationQueue.main.addOperation {completion(error)}
            }
        }
    }
    
    public func getUser(_ completion: @escaping (UserProfileModel?) -> Void) {
        queue.async {
            guard let filePath = self.filePath(forKey: "UserProfile.json"),
                  let jsonDataFile = try? Data(contentsOf: filePath),
                  let user = try? JSONDecoder().decode(UserProfileModel.self, from: jsonDataFile) else {return}
            self.main.async {completion(user)}
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
    
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                 in: .userDomainMask).first else {return nil}
        return documentURL.appendingPathComponent(key)
    }
    
}
