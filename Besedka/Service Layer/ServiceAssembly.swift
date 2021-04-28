//
//  ServiceAssembly.swift
//  Besedka
//
//  Created by Ivan Kopiev on 12.04.2021.
//

import Foundation

protocol ServiceProtocol {
    var firebase: FireBaseServiceProtocol {get}
    var fileManager: FileManagerProtocol {get}
    var parser: ParserServiceProtocol {get}
    var network: NetworkServiceProtocol {get}
    var animator: AnimationProtocol {get}
}

class ServiceAssembly: ServiceProtocol {
    
    lazy var firebase: FireBaseServiceProtocol = FirebaseService()
    lazy var fileManager: FileManagerProtocol = FileManagerGCD()
    lazy var parser: ParserServiceProtocol = ParserService()
    lazy var network: NetworkServiceProtocol = NetworkService()
    lazy var animator: AnimationProtocol = AnimationService()
}
