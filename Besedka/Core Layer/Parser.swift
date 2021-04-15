//
//  Parser.swift
//  Besedka
//
//  Created by Ivan Kopiev on 12.04.2021.
//

import Foundation

protocol ParserProtocol {
    func parse(json data: Data) -> UserProfile?
    func toData(from user: UserProfile) -> Data
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T?
    func encodeJSON<T: Encodable>(type: T.Type, data: T ) -> Data?

}

class Parser: ParserProtocol {
    
    func toData(from user: UserProfile) -> Data {
        guard let data = try? JSONEncoder().encode(user) else { return Data() }
        return data
    }
    
    func parse(json data: Data) -> UserProfile? {
        var user: UserProfile? 
        do {
            user = try JSONDecoder().decode(UserProfile.self, from: data)
        } catch {
            print(error.localizedDescription)
        }
        return user
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError.localizedDescription)
            return nil
        }
    }
    
    func encodeJSON<T: Encodable>(type: T.Type, data: T ) -> Data? {
        let encoder = JSONEncoder()
        do {
            let encoderData = try encoder.encode(data)
            return encoderData
        } catch let jsonError {
            print("Failed to encode JSON", jsonError.localizedDescription)
            return nil
        }
    }
    
}
