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
    func fetchMessages(from id: String, _ completion: @escaping ([MessageDB]) -> Void)

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
            
        }
    }
    
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
    
    func fetchMessages(from id: String, _ completion: @escaping ([MessageDB]) -> Void) {
        coreData?.performSave { context in
            let request = taskFetchRequest(channel: id)
            do {
                let channels = try context.fetch(request)  
                DispatchQueue.main.async {
                    completion(channels)

                }
                
            } catch let error {
                print("ERROR to fetch messages from DB", error.localizedDescription)
            }
        }

    }
    
    func taskFetchRequest(channel id: String) -> NSFetchRequest<MessageDB> {
        let fetchRequest: NSFetchRequest = MessageDB.fetchRequest()
        fetchRequest.fetchBatchSize = 35
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        fetchRequest.predicate = NSPredicate(format: "channel.identifier = %@", id)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = 1
        return fetchRequest
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
