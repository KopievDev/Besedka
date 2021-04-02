//
//  CoreDataStack.swift
//  Besedka
//
//  Created by Ivan Kopiev on 31.03.2021.
//

import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    private init() { }
    private var storeUrl: URL = {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory,
                                                          in: .userDomainMask).last else {
            fatalError("document path not found")
        }
        return documentsUrl.appendingPathComponent("Chat.sqlite")
    }()
    
    private let dataModelName = "Chat"
    private let dataModelExtension = "momd"

    // MARK: - init Stack
    
    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.dataModelName,
                                             withExtension: self.dataModelExtension) else {
            fatalError("model not found")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("managedObjectModel cound not be created")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: self.storeUrl,
                                               options: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
        return coordinator
    }()

    // MARK: - Contexts
    
    private lazy var writterContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()

    private(set) lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = writterContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    private func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }

    // MARK: - Save Context
    
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = saveContext()
        context.performAndWait { [weak self] in
            guard let self = self else {return}

            block(context)
            if context.hasChanges {
                self.performSave(in: context)
            }
        }
    }
    
    private func performSave(in context: NSManagedObjectContext) {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        if let parent = context.parent { performSave(in: parent) }
    }
    
    // MARK: - Core Data Logs
    
    func printAllMessages() {
        mainContext.perform {[weak self] in
            guard let self = self else {return}
            do {
                let count = try self.mainContext.count(for: MessageDB.fetchRequest())
                print("\(count) сообщений")
                let array = try self.mainContext.fetch(MessageDB.fetchRequest()) as? [MessageDB] ?? []
                array.forEach {
                    print($0.content, $0.senderName)
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func printChannelsCount() {
        mainContext.perform {[weak self] in
            guard let self = self else {return}
            do {
                let count = try self.mainContext.count(for: ChannelDB.fetchRequest())
                print("\(count) channels saved.")
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    func printMessagesCount() {
        mainContext.perform {[weak self] in
            guard let self = self else {return}
            do {
                let count = try self.mainContext.count(for: MessageDB.fetchRequest())
                print("\(count) messages saved.")
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func сountMessages(from channel: Channel?) {
        guard let channelInScope = channel else {return}
        mainContext.perform { [weak self] in
            guard let self = self else {return}
            let request: NSFetchRequest = ChannelDB.fetchRequest()
            request.predicate = NSPredicate(format: "identifier = %@", "\(channelInScope.identifier)")
            do {
                let channel = try self.mainContext.fetch(request)
                print("В канале \(channel.first?.name ?? "") сохранено -  \(channel.first?.messages?.count ?? 0) сообщения(й)")
                
                // Вывод сообщений канала
//                channel.first?.messages?.forEach { message in
//                    guard let mes = message as? MessageDB else { return }
//                    print(mes.content ?? "dnil")
//                }
            } catch {
                fatalError(error.localizedDescription)
            }

        }
    }
}
