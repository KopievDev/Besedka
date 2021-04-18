//
//  Avatar.swift
//  Besedka
//
//  Created by Ivan Kopiev on 18.04.2021.
//

import Foundation

struct Avatar: Codable {
    var tags: String?
    var imageURL: String?
    private enum CodingKeys: String, CodingKey {
        case tags
        case imageURL = "webformatURL"
    }
}
 
struct Response: Codable {
    var hits: [Avatar]?
}
