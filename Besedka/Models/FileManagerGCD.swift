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
    
    public func saveImageToFile(_ image: UIImage?, byName name: String, completion: @escaping ()->Void){
        
        queue.async {
            guard let pngData = image?.pngData(),
                  let filePath = self.filePath(forKey: name) else { return }
            try? pngData.write(to: filePath, options: .atomic)
            self.main.async {completion()}
        }
    }
    
    public func deleteFile(name: String){
        
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

            }
            catch let error as NSError {
                print("An error took place: \(error)")
            }
        }
    }
    
    
    public func getImageFromFile(name: String,
                                 runQueue: DispatchQueue,
                                 completionQueue: DispatchQueue,
                                 completion: @escaping (UIImage?) -> Void){
        runQueue.async {
            guard let filePath = self.filePath(forKey: name) else {return}
            guard let fileData = FileManager.default.contents(atPath: filePath.path) else {return}
            guard let image = UIImage(data: fileData) else {return}
            completionQueue.async {completion(image)}
        }
    }
    public func getUserFromFile(name: String, completion: @escaping (UserProfileModel?)->Void){
        queue.async {
            guard let path = Bundle.main.path(forResource: name, ofType: "json")  else {return}
            let url = URL(fileURLWithPath: path)
            guard let jsonDataFile = try? Data(contentsOf: url),
                  let user = try? JSONDecoder().decode(UserProfileModel.self, from: jsonDataFile) else {return}
            self.main.async {completion(user)}
        }
    }
    
    public func saveUserToFile(name: String, user: UserProfileModel?, completion: @escaping (()->Void) ){
        queue.async {
            sleep(5)
            guard  let path = Bundle.main.path(forResource: name, ofType: "json") else { return}
            let url = URL(fileURLWithPath: path)
            guard let user = user  else {return}
            try? JSONEncoder().encode(user).write(to: url)
            self.main.async {completion()}
        }
    }
    
    public func getThemeFromFile(completion: @escaping (String?)->Void){
        queue.async {
            guard let path = Bundle.main.path(forResource: "Theme", ofType: "plist")  else {return}
            let url = URL(fileURLWithPath: path)
            guard let object = NSDictionary(contentsOf: url),
                  let theme = object.value(forKey: "name") as? String else {return}
            self.main.async {completion(theme)}
        }
    }
    
    public func saveThemeFromFile(name theme: String?){
        queue.async {
            guard let name = theme else {return}
            let dict = NSMutableDictionary()
            guard let path = Bundle.main.path(forResource: "Theme", ofType: "plist")  else {return}
            let url = URL(fileURLWithPath: path)
            dict.setValue(name, forKey: "name")
            dict.write(to: url, atomically: true)
        }
    }

    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                 in: .userDomainMask).first else {return nil}
        return documentURL.appendingPathComponent(key + ".png")
    }
}


class FileManagerOperation: Operation {
    
    
    
    
}
