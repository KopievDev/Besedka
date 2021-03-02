//
//  UsersModel.swift
//  Besedka
//
//  Created by Ivan Kopiev on 28.02.2021.
//

import Foundation

struct User {
    var name : String
    var isOnline : Bool
    var isArchive : Bool
    var hasUnreadMessages: Bool
    var image : String? = nil
    var messages : [Messages]?
    var message: String? {
        return messages?.last?.message
    }
    var date : Date? {
        return messages?.last?.date
    }
    
    

}

struct Messages {
    var message : String? = nil
    var date : Date? = nil
    var toMe : Bool = false
}

let tonyStark = User(name: "Tony Stark", isOnline: true, isArchive: false, hasUnreadMessages: false,
                     messages: [
                        Messages(message: "What's up Bro", date: Date(), toMe: true),
                        Messages(message: "i'am fine", date: Date(), toMe: false),
                        Messages(message: "zbs", date: Date(), toMe: true),
                     ])

let lebowski = User(name: "Lebowski", isOnline: false, isArchive: false, hasUnreadMessages: true, image: nil,
                    messages: [
                    Messages(message: "Where's the money, Lebowski!?!?!?", date: Date(timeIntervalSinceNow: -100000000), toMe: false)])

let LebronJames = User(name: "Lebron", isOnline: true, isArchive: false, hasUnreadMessages: false, image: nil,
                    messages: [
                    Messages(message: "Where's the money, Lebowski!?!?!?", date: Date(timeIntervalSinceNow: -100000000), toMe: false)])
