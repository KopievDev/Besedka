//
//  ChannelDB+CoreDataClass.swift
//  Besedka
//
//  Created by Ivan Kopiev on 31.03.2021.
//
//

import Foundation
import CoreData
import Firebase

@objc(ChannelDB)
public class ChannelDB: NSManagedObject {
    
    convenience init(_ channel: Channel, context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = channel.identifier
        self.name = channel.name
        self.lastMessage = channel.lastMessage
        self.lastActivity = channel.lastActivity
    }
    
    convenience init?(dictionary: [String: Any], documentId: String, context: NSManagedObjectContext) {
        self.init(context: context)
        let name = dictionary["name"] as? String ?? ""
        let lastMessage = dictionary["lastMessage"] as? String ?? ""
        let lastActivity = dictionary["lastActivity"] as? Timestamp
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity?.dateValue()
        self.identifier  = documentId
    }
    
    convenience init?(dictionary: [String: Any], context: NSManagedObjectContext) {
        self.init(context: context)
        let name = dictionary["name"] as? String ?? ""
        let lastMessage = dictionary["lastMessage"] as? String ?? ""
        let lastActivity = dictionary["lastActivity"] as? Date ?? nil
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
        self.identifier  = dictionary["identifier"] as? String ?? ""
    }
}
