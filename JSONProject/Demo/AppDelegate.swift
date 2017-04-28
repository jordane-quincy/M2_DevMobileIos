//
//  AppDelegate.swift
//  Demo
//
//  Created by Mathilde Dumont on 24/01/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // reset database
        let realmServices = RealmServices()
        realmServices.resetDataBase()

        let tabBarController = UITabBarController()
        let myVC1 = AccueilViewController(nibName: "AccueilViewController", bundle: nil)
        let myVC2 = ResultatViewController(nibName: "ResultatViewController", bundle: nil)
        let myVC3 = SetupViewController(nibName: "SetupViewController", bundle: nil)
        let myVC4 = AideViewController(nibName: "AideViewController", bundle: nil)
        let controllers = [myVC1, myVC2, myVC3, myVC4]
        tabBarController.viewControllers = controllers
        window?.rootViewController = tabBarController
        
        // Add navigationController to tabBarController
        let navigationController = UINavigationController(rootViewController: tabBarController)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        myVC1.setupNavigationController(navigationController: navigationController)
        
        
        let firstImage = UIImage(named: "home")
        myVC1.tabBarItem = UITabBarItem(
            title: "Accueil",
            image: firstImage,
            tag: 1)
        let secondImage = UIImage(named: "resultat")
        myVC2.tabBarItem = UITabBarItem(
            title: "Résultat",
            image: secondImage,
            tag: 2)
        let thirdImage = UIImage(named: "setup")
        myVC3.tabBarItem = UITabBarItem(
            title: "Setup",
            image: thirdImage,
            tag: 3)
        let fourthImage = UIImage(named: "aide")
        myVC4.tabBarItem = UITabBarItem(
            title: "Aide",
            image: fourthImage,
            tag: 4)
        
        myVC2.tabBarItem.isEnabled = false
        myVC3.tabBarItem.isEnabled = false
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

