//
//  AppDelegate.swift
//  Besedka
//
//  Created by Ivan Kopiev on 13.02.2021.
//

import UIKit
#if DEBUG // Если схема запуска DEBUG :
let showLog = true
#else // если схема запуска RELEASE :
let showLog = false
#endif


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var state: String = "" //Состояние приложения

    //Сообщает делегату, что процесс запуска начался
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool{
      
        let defaults = UserDefaults.standard
        if let theme = defaults.string(forKey: "theme") {
            switch theme {
                    case "Classic":
                        Theme.current = LightTheme()
                    case "Night":
                        Theme.current = DarkTheme()
                    default:
                        Theme.current = DayTheme()
                    }
        }else {
            Theme.current = DayTheme()
        }
        Theme.current.apply(for: application)
        
        if showLog {
            print("#Run DEBUG scheme")
            state = #function
            print("The start of the method \(#function)")
        }else{
            print("#Run RELEASE scheme")
        }
        
        return true
    }
    
    //Сообщает делегату, что процесс запуска почти завершен и приложение почти готово к запуску.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if showLog {
        print("Application moved from \(state) to \(#function):  \(#function) ")
        state = #function
        }
        
        // Create navigation controller
        window = UIWindow(frame: UIScreen.main.bounds)
        let startController = ConversationsListViewController()
        let navigationController = UINavigationController(rootViewController: startController)


        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        
        return true
    }
    
    //Сообщает делегату, что приложение стало активным.
    func applicationDidBecomeActive(_ application: UIApplication) {

        if showLog {
        print("Application moved from \(state) to \(#function):  \(#function) ")
        state = #function
        }
        
      }
    
    //Сообщает делегату, что приложение вот-вот станет неактивным.
    func applicationWillResignActive(_ application: UIApplication) {

        if showLog {
        print("Application moved from \(state) to \(#function):  \(#function) ")
        state = #function
        }
        
    }
    
    //Сообщает делегату, что приложение теперь находится в фоновом режиме.
    func applicationDidEnterBackground(_ application: UIApplication) {

        if showLog {
        print("Application moved from \(state) to \(#function):  \(#function) ")
        state = #function
        }
    }
    //Сообщает делегату, что приложение вот-вот выйдет на передний план.
    func applicationWillEnterForeground(_ application: UIApplication) {

        if showLog {
        print("Application moved from \(state) to \(#function):  \(#function) ")
        state = #function
        }
    }
    //Сообщает делегату, когда приложение собирается завершить работу.
    func applicationWillTerminate(_ application: UIApplication) {

        if showLog {
        print("Application moved from \(state) to \(#function):  \(#function) ")
        state = #function
        }
    }
    
    
}

