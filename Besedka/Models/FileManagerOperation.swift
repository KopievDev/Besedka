//
//  FileManagerOperation.swift
//  Besedka
//
//  Created by Ivan Kopiev on 18.03.2021.
//

import UIKit

class FileManagerOperation: Operation {
    
    let operationQueue = OperationQueue()
    
    public func saveImageToFile(_ image: UIImage?,
                                byName name: String,
                                completion: @escaping () -> Void) {
        
        operationQueue.addOperation {
            guard let pngData = image?.pngData(),
                  let filePath = self.filePath(forKey: name) else { return }
            try? pngData.write(to: filePath, options: .atomic)
            OperationQueue.main.addOperation {completion()}
        }
    }
    
    public func saveUser(user: UserProfileModel?, completion: @escaping ((Error?) -> Void)) {
        operationQueue.addOperation {
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
    
    public func saveUserToFile(name: String,
                               user: UserProfileModel?,
                               completion: @escaping ((Error?) -> Void) ) {
        operationQueue.addOperation {
            guard  let path = Bundle.main.path(forResource: name, ofType: "json") else { return}
            let url = URL(fileURLWithPath: path)
            guard let user = user  else {return}
            do {
                try JSONEncoder().encode(user).write(to: url)
                OperationQueue.main.addOperation {completion(nil)}
            } catch let error {
                OperationQueue.main.addOperation {completion(error)}
            }
        }
    }
    
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                 in: .userDomainMask).first else {return nil}
        return documentURL.appendingPathComponent(key)
    }
    
}
