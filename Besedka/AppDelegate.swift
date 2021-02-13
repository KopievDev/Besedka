//
//  AppDelegate.swift
//  Besedka
//
//  Created by Ivan Kopiev on 13.02.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var state: String = "" //Состояние приложения
    
    //Сообщает делегату, что процесс запуска начался
    func application(_ application: UIApplication,
                     willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool{
        state = #function

        print("The start of the method \(#function)")
        return true
    }
    
    //Сообщает делегату, что процесс запуска почти завершен и приложение почти готово к запуску.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        print("Application moved from \(state) to \(#function):  \(#function) ")
        state = #function

        return true
    }
    
    //Сообщает делегату, что приложение стало активным.
    func applicationDidBecomeActive(_ application: UIApplication) {

        print("Application moved from \(state) to \(#function):  \(#function) ")
        state = #function
        
      }
    
    //Сообщает делегату, что приложение вот-вот станет неактивным.
    func applicationWillResignActive(_ application: UIApplication) {

        print("Application moved from \(state) to \(#function):  \(#function) ")
        state = #function
    }
    
    //Сообщает делегату, что приложение теперь находится в фоновом режиме.
    func applicationDidEnterBackground(_ application: UIApplication) {

        print("Application moved from \(state) to \(#function):  \(#function) ")
        state = #function
    }
    //Сообщает делегату, что приложение вот-вот выйдет на передний план.
    func applicationWillEnterForeground(_ application: UIApplication) {

        print("Application moved from \(state) to \(#function):  \(#function) ")
        state = #function
    }
    //Сообщает делегату, когда приложение собирается завершить работу.
    func applicationWillTerminate(_ application: UIApplication) {

        print("Application moved from \(state) to \(#function):  \(#function) ")
        state = #function
    }
}
