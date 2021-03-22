//
//  UsersModel.swift
//  Besedka
//
//  Created by Ivan Kopiev on 28.02.2021.
//

import Foundation

struct User {
    var name: String?
    var isOnline: Bool
    var isArchive: Bool
    var hasUnreadMessages: Bool
    var image: String?
    var messages: [Messages]?
    var lastMessage: String? {
        return messages?.last?.message
    }
    var date: Date? {
        return messages?.last?.date
    }
    
    enum ValueState {
        case isOnline
        case hasUnreadMessages
        case delete
        case isArchive
    }

}

struct Messages {
    var message: String?
    var date: Date?
    var toMe: Bool = false
}
