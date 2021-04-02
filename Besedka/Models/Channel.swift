//
//  Channel.swift
//  Besedka
//
//  Created by Ivan Kopiev on 21.03.2021.
//

import Foundation
import Firebase
import CoreData

struct Channel: Hashable {
    let identifier: String
    let name: String
    var lastMessage: String?
    var lastActivity: Date?
    var dictionary: [String: Any] {
        guard let lastDate = lastActivity else {
            return [
                "name": name,
                "lastMessage": lastMessage ?? "",
                "lastActivity": "" ]
        }
        return [
            "name": name,
            "lastMessage": lastMessage ?? "",
            "lastActivity": Timestamp(date: lastDate)]
    }
}

extension Channel {
    init?(dictionary: [String: Any], documentId: String) {
        let name = dictionary["name"] as? String ?? ""
        let lastMessage = dictionary["lastMessage"] as? String ?? ""
        let lastActivity = dictionary["lastActivity"] as? Timestamp 
        self.init(identifier: documentId, name: name, lastMessage: lastMessage, lastActivity: lastActivity?.dateValue())
        
    }
    init?(_ channelDB: ChannelDB) {
        self.identifier = channelDB.identifier
        self.name = channelDB.name
        self.lastMessage = channelDB.lastMessage
        self.lastActivity = channelDB.lastActivity
    }
    
    init(name: String) {
        self.name = name
        self.identifier = ""
        
    }    
}
