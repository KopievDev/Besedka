//
//  Message.swift
//  Besedka
//
//  Created by Ivan Kopiev on 21.03.2021.
//

import Foundation
import Firebase

let myId = UIDevice.current.identifierForVendor?.uuidString ?? "fuu"

struct Message {
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
    var dictionary: [String: Any] {
        return [
            "content": content,
            "senderName": senderName,
            "senderId": senderId,
            "created": Timestamp(date: created)
        ]
    }}

extension Message {
    init?(dictionary: [String: Any]) {
        let content = dictionary["content"] as? String ?? ""
        let senderName = dictionary["senderName"] as? String ?? ""
        let senderId = dictionary["senderId"] as? String ?? ""
        let created = dictionary["created"] as? Timestamp ?? Timestamp(date: Date())
        self.init(content: content, created: created.dateValue(), senderId: senderId, senderName: senderName)
    }
    
    init?(content: String) {
        self.content = content
        self.created = Date()
        self.senderName = "Ivan"
        self.senderId = myId
    }
    
    init?(content: String, name: String) {
        self.content = content
        self.created = Date()
        self.senderName = name
        self.senderId = myId
        
    }
}
