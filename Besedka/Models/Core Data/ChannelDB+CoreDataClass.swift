//
//  ChannelDB+CoreDataClass.swift
//  Besedka
//
//  Created by Ivan Kopiev on 31.03.2021.
//
//

import Foundation
import CoreData

@objc(ChannelDB)
public class ChannelDB: NSManagedObject {

    convenience init(_ channel: Channel, context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = channel.identifier
        self.name = channel.name
        self.lastMessage = channel.lastMessage
        self.lastActivity = channel.lastActivity
    }
    
}
