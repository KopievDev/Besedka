//
//  FirebaseService.swift
//  Besedka
//
//  Created by Ivan Kopiev on 22.03.2021.
//

import Foundation
import Firebase

protocol FireBaseServiceProtocol {
    typealias DictionaryData = [String: Any]
    func addSortedChannelListener(_ completion: @escaping ([Channel]) -> Void)
    func addSortedMessageListener(from channel: String, completion: @escaping ([Message]) -> Void)
    func addNew(channel name: Channel?)
    func addNew(message content: Message?, to channel: String)
    func delete(_ channel: ChannelDB)
    func delete(_ message: Message, in channel: String)
    func rename(_ channel: ChannelDB, to name: String)
    func change(_ message: Message, text content: String, in channel: String)
    func addListner(_ compeltion: @escaping ([DictionaryData]) -> Void)
    func addListnerMessegesFrom(channel id: String, _ compeltion: @escaping ([DictionaryData]) -> Void)

}

class FirebaseService: FireBaseServiceProtocol {
    
    let reference = Firestore.firestore().collection("channels")
    
    public  func addSortedChannelListener(_ completion: @escaping ([Channel]) -> Void) {
        reference.order(by: "name", descending: true).addSnapshotListener { (snapshot, _) in
            guard let document = snapshot?.documents else {
                print("no channels")
                return
            }
            // Channels out
            let channels = document.compactMap({ (snap) -> Channel? in
                let data = snap.data()
                return Channel(dictionary: data, documentId: snap.documentID )
            })
            
            DispatchQueue.main.async {
                completion(channels)
            }
        }
        
    }
    
    func addListner(_ compeltion: @escaping ([DictionaryData]) -> Void) {
        reference.order(by: "name", descending: true).addSnapshotListener { (snapshot, _) in
            guard let document = snapshot?.documents else {
                print("no channels")
                return
            }
            var dataArray = [DictionaryData]()
            document.forEach {doc in
                var dictionary = doc.data()
                dictionary["identifier"] = doc.documentID
                let lastActivity = dictionary["lastActivity"] as? Timestamp
                dictionary["lastActivity"] = lastActivity?.dateValue()
                dataArray.append(dictionary)
            }
            DispatchQueue.global().async {
                compeltion(dataArray)
            }
        }
    }
    
    func addListnerMessegesFrom(channel id: String, _ compeltion: @escaping ([DictionaryData]) -> Void) {
        reference.document(id).collection("messages").order(by: "created").addSnapshotListener { (snapshot, _) in
            guard let document = snapshot?.documents else {
                print("no messages")
                return
            }
            var dataArray = [DictionaryData]()
            document.forEach {doc in
                var dictionary = doc.data()
                dictionary["identifier"] = doc.documentID
                let created = dictionary["created"] as? Timestamp ?? Timestamp(date: Date())
                dictionary["created"] = created.dateValue()
                dataArray.append(dictionary)
            }
            DispatchQueue.global().async {
                compeltion(dataArray)
            }
        }
    }
    
    public  func addSortedMessageListener(from channel: String, completion: @escaping ([Message]) -> Void) {
        reference.document(channel).collection("messages").order(by: "created").addSnapshotListener { (snapshot, _) in
            guard let document = snapshot?.documents else {
                print("no messages")
                return
            }
            let message = document.compactMap({ (snap) -> Message? in
                let data = snap.data()
                return Message(dictionary: data, document: snap.documentID)
            })
            DispatchQueue.main.async {
                completion(message)
            }
        }
    }
    
    public func addNew(channel name: Channel?) {
        guard let channel = name else {return}
        reference.addDocument(data: channel.dictionary)
    }
    
    public func addNew(message content: Message?, to channel: String) {
        guard let mes = content else {return}
        self.reference.document(channel).collection("messages").addDocument(data: mes.dictionary)
    }
    
    public func rename(_ channel: ChannelDB, to name: String) {
        
        reference.document(channel.identifier).setData([ "name": name ], merge: true)
        
    }

    public func change(_ message: Message, text content: String, in channel: String) {
        
        self.reference.document(channel)
            .collection("messages")
            .document(message.identifier)
            .setData([ "content": content ], merge: true)
    }
    
    public func delete(_ channel: ChannelDB) {
        
        self.reference.document(channel.identifier).delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    public func delete(_ message: Message, in channel: String) {
        
        self.reference.document(channel).collection("messages").document(message.identifier).delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    deinit {
        print("Deinit firebase")
    }
}
