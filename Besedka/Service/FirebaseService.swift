//
//  FirebaseService.swift
//  Besedka
//
//  Created by Ivan Kopiev on 22.03.2021.
//

import Foundation
import Firebase

class FirebaseService {
    
    let reference = Firestore.firestore().collection("channels")
    
    public  func listenerChannels(listener: @escaping FIRQuerySnapshotBlock) {
        reference.order(by: "name").addSnapshotListener(listener)
    }
    
    public  func addChannelListener(_ completion: @escaping ([Channel]) -> Void) {
        reference.addSnapshotListener { (snapshot, _) in
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
    
    public  func addSortedChannelListener(_ completion: @escaping ([Channel]) -> Void) {
        reference.order(by: "lastActivity", descending: true).addSnapshotListener { (snapshot, _) in
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

    public  func listenerMessages(from channel: String, listener: @escaping FIRQuerySnapshotBlock) {
        reference.document(channel).collection("messages").addSnapshotListener(listener)
    }
    
    public  func addMessageListener(from channel: String, completion: @escaping ([Message]) -> Void) {
        reference.document(channel).collection("messages").addSnapshotListener { (snapshot, _) in
            guard let document = snapshot?.documents else {
                print("no messages")
                return
            }
            let message = document.compactMap({ (snap) -> Message? in
                let data = snap.data()
                return Message(dictionary: data, document: snap.documentID)
            })
            
            let sortedMessages = message.sorted { $0.created < $1.created }
            DispatchQueue.global(qos: .userInitiated).async {
                completion(sortedMessages)
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
    public func getMessages(from channel: String, completion: @escaping ([Message]) -> Void) {
        let messagesRef = reference.document(channel).collection("messages")
        messagesRef.getDocuments { (snapshot, _) in
            guard let document = snapshot?.documents else {
                print("no messages")
                return
            }
            let message = document.compactMap({ (snap) -> Message? in
                let data = snap.data()
                return Message(dictionary: data, document: snap.documentID)
            })
            
            let sortedMessages = message.sorted { $0.created < $1.created }
            DispatchQueue.global(qos: .userInitiated).async {
                completion(sortedMessages)
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
    
    func deleteChannel(uid: String) {
        reference.document(uid).delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    public func rename(_ channel: Channel, to name: String) {
        
        reference.document(channel.identifier).setData([ "name": name ], merge: true)
        
    }
    // Todo
    public func change(_ message: Message, text content: String, in channel: String) {
        
        self.reference.document(channel)
            .collection("messages")
            .document(message.identifier)
            .setData([ "content": content ], merge: true)
    }
    
    public func delete(_ channel: Channel) {
        
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
