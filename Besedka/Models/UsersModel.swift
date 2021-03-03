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

let tonyStark = User(name: "Tony Stark", isOnline: true, isArchive: false, hasUnreadMessages: false, image: "Tony",
                     messages: [
                        Messages(message: "What's up Bro", date: Date(timeIntervalSinceNow: -2000), toMe: true),
                        Messages(message: "i'am fine", date: Date(timeIntervalSinceNow: -1000), toMe: false),
                        Messages(message: "zbs", date: Date(), toMe: true),
                        Messages(message: "zbs", date: Date(), toMe: true),Messages(message: "zbs", date: Date(), toMe: true),
                        Messages(message: "zbs", date: Date(), toMe: true),
                        Messages(message: "zbs", date: Date(), toMe: false),
                        Messages(message: "zbs", date: Date(), toMe: true),
                        Messages(message: "zbs", date: Date(), toMe: true),
                        Messages(message: "zbs", date: Date(), toMe: false),
                        Messages(message: "zrfrfrbs", date: Date(), toMe: true),
                        Messages(message: "rfrfrzbs", date: Date(), toMe: false),
                        Messages(message: "zbs", date: Date(), toMe: true),
                        Messages(message: "zbs", date: Date(), toMe: true),
                        Messages(message: "zbs", date: Date(), toMe: false),
                        Messages(message: "zbs", date: Date(), toMe: false),
                        Messages(message: "zbs", date: Date(), toMe: true),
                        Messages(message: "zbs", date: Date(), toMe: true),
                        Messages(message: "zbs", date: Date(), toMe: false),
                        Messages(message: "zrfrfrbs", date: Date(), toMe: true),
                        Messages(message: "rfrfrzbs", date: Date(), toMe: false),
                        Messages(message: "zbs", date: Date(), toMe: true),
                        Messages(message: "zbs", date: Date(), toMe: true),
                        Messages(message: "zbs", date: Date(), toMe: false),
                        Messages(message: "zbs", date: Date(), toMe: false),
                        Messages(message: "zbs", date: Date(), toMe: true),
                        Messages(message: "zbs", date: Date(), toMe: true),
                        Messages(message: "zbs", date: Date(), toMe: false),
                        Messages(message: "zrfrfrbs", date: Date(), toMe: true),
                        Messages(message: "rfrfrzbs", date: Date(), toMe: false),
                        Messages(message: "zbs", date: Date(), toMe: true),
                        Messages(message: "zbs", date: Date(), toMe: true),
                        Messages(message: "zbs", date: Date(), toMe: false),
                     ])

let lebowski = User(name: "Lebowski", isOnline: false, isArchive: false, hasUnreadMessages: false, image: "lebowski",
                    messages: [
                        Messages(message: "Where's the money, Lebowski!?!?!?", date: Date(timeIntervalSinceNow: -100000000), toMe: false)])

let LebronJames = User(name: "Lebron", isOnline: true, isArchive: false, hasUnreadMessages: false, image: "lebron",
                       messages: [
                        Messages(message: "Go basket?", date: Date(timeIntervalSinceNow: -100000), toMe: false),
                        Messages(message: "Go Bro", date: Date(timeIntervalSinceNow: -100000), toMe: true),
                       ])

let ilonMask = User(name: "Ilon Mask", isOnline: true, isArchive: false, hasUnreadMessages: false, image: "ilon",
                    messages: [
                    Messages(message: "Ну как тебе мое приложение?", date: Date(timeIntervalSinceNow: -100000), toMe: false),
                        Messages(message: "Офигенно!", date: Date(timeIntervalSinceNow: -100000), toMe: true),

                    ])


let walterWhite = User(name: "Walter White", isOnline: true, isArchive: false, hasUnreadMessages: true, image: "walter",
                    messages: [
                    Messages(message: "Джесси не видел?", date: Date(timeIntervalSinceNow: -100000), toMe: false)])

let myDog = User(name: "Мой пёс", isOnline: true, isArchive: false, hasUnreadMessages: false, image: "dog",
                    messages: [
                    Messages(message: "Гав-гав!", date: Date(timeIntervalSinceNow: -100000), toMe: true)])


let subZero = User(name: "Subzero", isOnline: true, isArchive: false, hasUnreadMessages: false, image: "subzero",
                   messages: [
                    Messages(message: "Опять ты хрень сморозил!!?", date: Date(timeIntervalSinceNow: -100000), toMe: false),
                    Messages(message: "Тебе никогда не стать iOS разработчиком!!! Лол", date: Date(timeIntervalSinceNow: -100000), toMe: true)])
                    



let spam = User(name: "spam", isOnline: false, isArchive: true, hasUnreadMessages: false, image: "spam",
                    messages: [
                    Messages(message: "Продам гараж и сделаю кухню - звони!", date: Date(timeIntervalSinceNow: -100000), toMe: true)])


let jessyPinkman = User(name: "Jessy Pinkman", isOnline: true, isArchive: true, hasUnreadMessages: false, image: "jessy",
                    messages: [
                    Messages(message: "Тебя ищет Волтер", date: Date(timeIntervalSinceNow: -100000), toMe: false)])


let sber = User(name: "900 protected AUE", isOnline: false, isArchive: true, hasUnreadMessages: true, image: "sber",
                    messages: [
                    Messages(message: "Здравствуйте, это служба безопасности. Назовите номер карты ", date: Date(timeIntervalSinceNow: -100000), toMe: true)])
//
let nogotochki = User(name: "Ноготочки", isOnline: false, isArchive: true, hasUnreadMessages: true, image: "nogotochki",
                    messages: [
                    Messages(message: "Здравствуйте, шилак не интересует?? НЕДОРОГО!)) ", date: Date(timeIntervalSinceNow: -100000), toMe: true)])

let frodo = User(name: "Фродо Бэгинс", isOnline: false, isArchive: true, hasUnreadMessages: true, image: "frodo",
                 messages: [
                    Messages(message: "Пccc...", date: Date(timeIntervalSinceNow: -100020), toMe: true),
                    Messages(message: "Привет! Золотые кольца не интересуют?", date: Date(timeIntervalSinceNow: -100000), toMe: true)
                 ])

let batman = User(name: "Batman", isOnline: false, isArchive: true, hasUnreadMessages: true, image: "batman",
                    messages: [
                    Messages(message: "Привет! Детонатор не видел??", date: Date(timeIntervalSinceNow: -100000), toMe: true)])

let deadpool = User(name: "Deadpool", isOnline: true, isArchive: true, hasUnreadMessages: false, image: "deadpool")

let joker = User(name: "Joker", isOnline: false, isArchive: true, hasUnreadMessages: true, image: "joker",
                    messages: [
                    Messages(message: "Лол", date: Date(timeIntervalSinceNow: -100000), toMe: true),
                        Messages(message: "Детонатор у меня", date: Date(timeIntervalSinceNow: -100000), toMe: true),
                        Messages(message: "Только крылатому с острыми ушами не говори!", date: Date(timeIntervalSinceNow: -100000), toMe: true),
                        Messages(message: "Окай", date: Date(timeIntervalSinceNow: -100000), toMe: false) ])
