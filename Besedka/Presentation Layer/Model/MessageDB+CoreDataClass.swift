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
}
