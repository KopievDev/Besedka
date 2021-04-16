//
//  ServiceAssembly.swift
//  Besedka
//
//  Created by Ivan Kopiev on 12.04.2021.
//

import Foundation

class ServiceAssembly {
    
    lazy var firebase: FireBaseServiceProtocol = FirebaseService()
    lazy var fileManager: FileManagerProtocol = FileManagerGCD()
}
