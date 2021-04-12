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
}
