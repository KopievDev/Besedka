//
//  ViewController.swift
//  Besedka
//
//  Created by Ivan Kopiev on 13.02.2021.
//

import UIKit

class ViewController: UIViewController {

    var stateViewController: String = "" // Состояние ViewController
    
    
    //MARK: - LoadView
    //Этот метод вызывается при создании View
    override func loadView() {
        super.loadView()
        
        if showLog {
            self.stateViewController = #function
            print("The start of the method \(#function)")
        }
    }
    
    //MARK: - LoadDidView
    //Этот метод загружается один раз в жизненном цикле ViewControllera .Он вызывается, когда загружаются все View
    override func viewDidLoad() {
        super.viewDidLoad()

        if showLog {
        print("ViewController moved from \(stateViewController) to \(#function):  \(#function) ")
        self.stateViewController = #function
        }
        
    }
    
    //MARK: - viewWillAppear
    //Этот метод вызывается каждый раз перед тем, как вьюшка будет видна и перед тем, как будет настроена какая-либо анимация
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if showLog {
        print("ViewController moved from \(stateViewController) to \(#function):  \(#function) ")
        self.stateViewController = #function
        }
        
    }
    
    //MARK: - viewDidAppear
    //Этот метод вызывается после загрузки View на экране.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if showLog {
        print("ViewController moved from \(stateViewController) to \(#function):  \(#function) ")
        self.stateViewController = #function
        }
        
    }
    
    //MARK: - viewWillLayoutSubviews
    //Этот метод ничего не делает по умолчанию. Когда границы вида изменяются, он корректирует положение своих подвидов.
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if showLog {
        print("ViewController moved from \(stateViewController) to \(#function):  \(#function) ")
        self.stateViewController = #function
        }
        
    }
    
    //MARK: - viewDidLayoutSubviews
    //Этот метод вызывается после того, как viewController был приспособлен к своему подвиду после изменения его привязки
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if showLog {
        print("ViewController moved from \(stateViewController) to \(#function):  \(#function) ")
        self.stateViewController = #function
        }
        
    }
    
    //MARK: - viewWillDisappear
    //Этот метод вызывается до того, как вьюшка будет удалена из иерархии вьюшек.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if showLog {
        print("ViewController moved from \(stateViewController) to \(#function):  \(#function) ")
        self.stateViewController = #function
        }
        
    }
    
    //MARK: - viewDidDisappear
    //Этот метод вызывается после того, как вьюшка будет удалена из иерархии вьюшек.
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if showLog {
        print("ViewController moved from \(stateViewController) to \(#function):  \(#function) ")
        self.stateViewController = #function
        }
        
    }
    
}


