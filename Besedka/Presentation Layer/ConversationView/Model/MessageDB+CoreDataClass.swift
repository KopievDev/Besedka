//
//  MessageDB+CoreDataClass.swift
//  Besedka
//
//  Created by Ivan Kopiev on 31.03.2021.
//
//

import Foundation
import CoreData

@objc(MessageDB)
public class MessageDB: NSManagedObject {
    
    convenience init(_ message: Message, context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = message.identifier
        self.content = message.content
        self.senderName = message.senderName
        self.created = message.created
        self.senderId = message.senderId
    }
    convenience init(_ dictionary: [String: Any], context: NSManagedObjectContext) {
        self.init(context: context)
        self.content = dictionary["content"] as? String ?? ""
        self.senderName = dictionary["senderName"] as? String ?? ""
        self.senderId = dictionary["senderId"] as? String ?? ""
        self.created = dictionary["created"] as? Date ?? Date()
        self.identifier = dictionary["identifier"] as? String ?? ""
        
    }

}
