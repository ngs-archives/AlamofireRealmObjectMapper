//
//  AppDelegate.swift
//  AlamofireRealmObjectMapperExample
//
//  Created by Atsushi Nagase on 5/19/16.
//  Copyright © 2016 Atsushi Nagase. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            UINavigationController(rootViewController: GistsViewController(style: .plain)),
            UINavigationController(rootViewController: SectionedGistsViewController(style: .plain))
        ]
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }
}

