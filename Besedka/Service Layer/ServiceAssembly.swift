//
//  ServiceAssembly.swift
//  Besedka
//
//  Created by Ivan Kopiev on 12.04.2021.
//

import UIKit

protocol ServiceProtocol {
    var firebase: FireBaseServiceProtocol {get}
    var fileManager: FileManagerProtocol {get}
    var parser: ParserServiceProtocol {get}
    var network: NetworkServiceProtocol {get}
    var animator: AnimationProtocol {get}
    func transitionAnimator(fromView: UIView, isPresenting: Bool) -> UIViewControllerAnimatedTransitioning
}

class ServiceAssembly: ServiceProtocol {
    
    static let shared: ServiceProtocol = ServiceAssembly()
    private init() {}
    
    lazy var firebase: FireBaseServiceProtocol = FirebaseService()
    lazy var fileManager: FileManagerProtocol = FileManagerGCD()
    lazy var parser: ParserServiceProtocol = ParserService()
    lazy var network: NetworkServiceProtocol = NetworkService()
    lazy var animator: AnimationProtocol = AnimationService()
    func transitionAnimator(fromView: UIView, isPresenting: Bool) -> UIViewControllerAnimatedTransitioning {
        return CircleTransitionAnimator(fromView: fromView, isPresenting: isPresenting)
    }
}
