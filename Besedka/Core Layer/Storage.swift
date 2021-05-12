//
//  Storage.swift
//  Besedka
//
//  Created by Ivan Kopiev on 12.04.2021.
//

import Foundation

protocol StorageProtocol {
    func urlPath() -> URL?
    func stringPath() -> String
    func removeFile(atPath path: String)
    func contents(atPath path: String) -> Data?
    func getPrivateData(byKey key: String) -> String 

}

class Storage: StorageProtocol {
    
    func contents(atPath path: String) -> Data? {
        guard let fileData = FileManager.default.contents(atPath: path ) else {return nil}
        return fileData
    }
    
    func removeFile(atPath path: String) {
        do {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: path) {
                try fileManager.removeItem(atPath: path)
            } else {
                print("File does not exist")
            }
        } catch let error as NSError {
            print("An error took place: \(error)")
        }
    }
    
    func stringPath() -> String {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {return String()}
        return path.appendingFormat("/")
    }
    
    func urlPath() -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                 in: .userDomainMask).first else {return nil}
        return documentURL
    }
    
    func getPrivateData(byKey key: String) -> String {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist") else {return "bundle error"}
        let dictionary = NSDictionary(contentsOfFile: path)
        guard let output = dictionary?[key] as? String else {return "key error"}
        return output
    }
}
