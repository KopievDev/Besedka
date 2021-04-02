//
//  MessageDB+CoreDataProperties.swift
//  Besedka
//
//  Created by Ivan Kopiev on 31.03.2021.
//
//

import Foundation
import CoreData

extension MessageDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageDB> {
        return NSFetchRequest<MessageDB>(entityName: "MessageDB")
    }

    @NSManaged public var content: String
    @NSManaged public var created: Date
    @NSManaged public var identifier: String
    @NSManaged public var senderId: String
    @NSManaged public var senderName: String
    @NSManaged public var channel: ChannelDB?

}
