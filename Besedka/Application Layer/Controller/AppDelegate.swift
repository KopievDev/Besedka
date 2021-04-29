//
//  AppDelegate.swift
//  Besedka
//
//  Created by Ivan Kopiev on 13.02.2021.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coreDataService: CoreDataProtocol?
    lazy var serviceAssembly: ServiceAssembly = ServiceAssembly()
    lazy var coreAssembly: CoreAssembly = CoreAssembly()
    // Сообщает делегату, что процесс запуска начался
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        coreDataService = CoreDataService(coreData: coreAssembly.coreData)

        let fileOpener = serviceAssembly.fileManager
        fileOpener.getTheme { (theme) in
            guard let name = theme else {return}
            switch name {
            case "Classic":
                Theme.current = LightTheme()
            case "Night":
                Theme.current = DarkTheme()
            default:
                Theme.current = DayTheme()
            }
            Theme.current.apply(for: application)
        }
        
        return true
    }
    
    // Сообщает делегату, что процесс запуска почти завершен и приложение почти готово к запуску.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Create navigation controller
        window = UIWindow(frame: UIScreen.main.bounds)
        let startController = ConversationsListViewController()
        let navigationController = UINavigationController(rootViewController: startController)
        startController.coreDataService = coreDataService
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
    
    // Сообщает делегату, что приложение стало активным.
    func applicationDidBecomeActive(_ application: UIApplication) {
      }
    
    // Сообщает делегату, что приложение вот-вот станет неактивным.
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    // Сообщает делегату, что приложение теперь находится в фоновом режиме.
    func applicationDidEnterBackground(_ application: UIApplication) {

    }
    // Сообщает делегату, что приложение вот-вот выйдет на передний план.
    func applicationWillEnterForeground(_ application: UIApplication) {

    }
    // Сообщает делегату, когда приложение собирается завершить работу.
    func applicationWillTerminate(_ application: UIApplication) {
        try? coreDataService?.coreData?.mainContext.save()
    }
    
}
