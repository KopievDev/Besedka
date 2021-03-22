//
//  Channel.swift
//  Besedka
//
//  Created by Ivan Kopiev on 21.03.2021.
//

import Foundation
import Firebase

struct Channel {
    let identifier: String?
    let name: String
    var lastMessage: String?
    var lastActivity: Date?
    var dictionary: [String: Any] {
        return [
            "name": name,
            "lastMessage": lastMessage ?? "",
            "lastActivity": Timestamp(date: lastActivity ?? Date())
        ]
        
    }
}

extension Channel {
    init?(dictionary: [String: Any], documentId: String) {
        let name = dictionary["name"] as? String ?? ""
        let lastMessage = dictionary["lastMessage"] as? String ?? ""
        let lastActivity = dictionary["lastActivity"] as? Timestamp ?? Timestamp(date: Date())
        self.init(identifier: documentId, name: name, lastMessage: lastMessage, lastActivity: lastActivity.dateValue())
        
    }
    
    init(name: String) {
        self.name = name
        self.identifier = nil
        
    }    
}
