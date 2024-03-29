//
//  CoreAssembly.swift
//  Besedka
//
//  Created by Ivan Kopiev on 12.04.2021.
//

import Foundation

class CoreAssembly {
    private init() {}
    static let shared = CoreAssembly()
    lazy var parser: ParserProtocol = Parser()
    lazy var storage: StorageProtocol = Storage()
    lazy var coreData: CoreDataStackProtocol = CoreDataStack()
    lazy var network: NetworkProtocol = Network()
    lazy var cacheImage: ImageCacheProtocol = ImageCache()
}
