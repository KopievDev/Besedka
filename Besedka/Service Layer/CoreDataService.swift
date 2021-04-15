//
//  CoreDataService.swift
//  Besedka
//
//  Created by Ivan Kopiev on 13.04.2021.
//

import Foundation
import CoreData

enum ChatObjects {
        case Message, Channel
    }

protocol CoreDataProtocol {
    typealias DATA = [String: Any]
    var coreData: CoreDataStackProtocol? {get set}
    func printCount(object: ChatObjects)
    func save(object: ChatObjects, data: DATA)
    func save(objects: ChatObjects, data: [DATA])
    func save(messages: [DATA], from channel: String)
    func delete(object: ChatObjects, id: String)
    func fetchChannels(_ completion: @escaping ([ChannelDB]) -> Void)
    func fetchMessages(_ completion: @escaping ([MessageDB]) -> Void)

}

class CoreDataService: CoreDataProtocol {
    
    var coreData: CoreDataStackProtocol?

    init(coreData: CoreDataStackProtocol) {
        self.coreData = coreData
    }
    func save(objects: ChatObjects, data: [DATA]) {
        switch objects {
        case .Channel:
            coreData?.performSave { context in
                
                let channelsArray = data.compactMap { dict -> ChannelDB? in
                    return ChannelDB(dictionary: dict, context: context)
                }
                
                do {
                    try context.obtainPermanentIDs(for: channelsArray )
                } catch let error {
                    print(error, "obtain error")
                }
                
                let channelsFromDB = try? context.fetch(ChannelDB.fetchRequest()) as? [ChannelDB] ?? []
                channelsFromDB?.forEach { channel in
                    if !channelsArray.contains(channel) {
                        context.delete(channel)
                    }
                }
            }
        case .Message:
            coreData?.performSave { context in
                
                let messageArray = data.compactMap { dict -> MessageDB? in
                    return MessageDB(dict, context: context)
                }
                do {
                    try context.obtainPermanentIDs(for: messageArray )
                } catch let error {
                    print(error, "obtain error")
                }

                let messageFromDB = try? context.fetch(MessageDB.fetchRequest()) as? [MessageDB] ?? []
                messageFromDB?.forEach { message in
                    print(message)
                    if !messageArray.contains(message) {
                        context.delete(message)
                    }
                }
            }
        }
    }
    
    func save(messages: [DATA], from channel: String) {
        
        coreData?.performSave { context in
            
            let requestChannel: NSFetchRequest = ChannelDB.fetchRequest()
            requestChannel.predicate = NSPredicate(format: "identifier = %@", channel)
            var currenChannel: ChannelDB?
            
            do {
                 let currentChannels = try context.fetch(requestChannel)
                print(currentChannels.first?.name)
                if currentChannels.first != nil {
                    currenChannel = currentChannels.first
                }
                 
            } catch {
                print(error)
            }
            
            let messageArray = messages.compactMap { dict -> MessageDB? in
                let message = MessageDB(dict, context: context)
                let channel1 = currenChannel
                channel1?.addToMessages(message)
                
                return message
            }
            
            do {
                try context.obtainPermanentIDs(for: messageArray )
            } catch let error {
                print(error, "obtain error")
            }
            
            print("DEBUG LISTNER:", currenChannel?.name)
//            if let chan = currenChannel {
//                messageArray.forEach { message in
//                    chan.addToMessages(message)
//                }
//            }
           
        }
    }
//
//    func save(messages: [DATA], from channel: ChannelDB) {
//
//        coreData?.performSave { context in
//
//            let messageArray = messages.compactMap { dict -> MessageDB? in
//                return MessageDB(dict, context: context)
//            }
//
//            do {
//                try context.obtainPermanentIDs(for: messageArray )
//            } catch let error {
//                print(error, "obtain error")
//            }
//
//            let requestChannel: NSFetchRequest = ChannelDB.fetchRequest()
//            requestChannel.predicate = NSPredicate(format: "identifier = %@", channel.identifier)
//
//            var currenChannel: ChannelDB?
//            do {
//                let currentChannels = try context.fetch(requestChannel)
//                currenChannel = currentChannels.first
//            } catch {
//                print(error)
//            }
//            print("DEBUG LISTNER:", currenChannel?.name)
//            if let chan = currenChannel {
//                messageArray.forEach { message in
//                    chan.addToMessages(message)
//                }
//            }
//
//            let id = channel.identifier
//            let request: NSFetchRequest = MessageDB.fetchRequest()
//            request.predicate = NSPredicate(format: "channel = %@", id)
//
//            let messageFromDB = try? context.fetch(request)
//            messageFromDB?.forEach { message in
//                print(message)
//                if !messageArray.contains(message) {
//                    context.delete(message)
//                }
//            }
//        }
//    }
    
    func fetchChannels(_ completion: @escaping ([ChannelDB]) -> Void) {
        coreData?.performSave { context in
            do {
                let channels = try context.fetch(ChannelDB.fetchRequest()) as? [ChannelDB] ?? []
                completion(channels)
                
            } catch let error {
                print("ERROR to fetch channels from DB", error.localizedDescription)
            }
        }
    }
    
    func fetchMessages(_ completion: @escaping ([MessageDB]) -> Void) {
        coreData?.performSave { context in
            do {
                let channels = try context.fetch(ChannelDB.fetchRequest()) as? [MessageDB] ?? []
                completion(channels)
                
            } catch let error {
                print("ERROR to fetch messages from DB", error.localizedDescription)
            }
        }

    }
    
    func printCount(object: ChatObjects) {
        print("count")
        switch object {
        case .Channel:
            printChannelsCount()
        case .Message:
            printMessagesCount()
        }
    }
    
    func save(object: ChatObjects, data: [String: Any]) {
        print("save")
        switch object {
        case .Channel:
            coreData?.performSave { context in
                _ = ChannelDB(dictionary: data, context: context)
            }
            
        case .Message:
            coreData?.performSave { context in
                _ = MessageDB(data, context: context)
            }
        }
    }
    
    func delete(object: ChatObjects, id: String) {
        print("delete")
        switch object {
        case .Channel:
            delete(channel: id)
        case .Message:
            delete(channel: id)
        }

    }
    
    func printChannelsCount() {
        coreData?.performSave { context in
            do {
                let count = try context.count(for: ChannelDB.fetchRequest())
                print("\(count) channels saved.")
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func printMessagesCount() {
        coreData?.performSave { context in
            do {
                let count = try context.count(for: MessageDB.fetchRequest())
                print("\(count) messages saved.")
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func delete(channel id: String) {
        coreData?.performSave { context in
            let request: NSFetchRequest = ChannelDB.fetchRequest()
            request.predicate = NSPredicate(format: "identifier = %@", id)
            
            do {
                let currentChannel = try context.fetch(request)
                if let entityToDelete = currentChannel.first {
                    context.delete(entityToDelete)
                    print(entityToDelete.name, " : Удалено")
                }
            } catch {
                print(error)
            }
        }
        
    }

}
