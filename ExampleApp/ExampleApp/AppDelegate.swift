//
//  AppDelegate.swift
//  ExampleApp
//
//  Created by Mohanraj on 13/11/25.
//

import UIKit
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let tabBar = UITabBarController()
        
        let uiKitVC = UINavigationController(rootViewController: UIKitDemoViewController())
        uiKitVC.tabBarItem = UITabBarItem(title: "UIKit", image: UIImage(systemName: "square.grid.2x2"), tag: 0)
        
        let swiftUIC = UIHostingController(rootView: SwiftUIDemoView())
        swiftUIC.tabBarItem = UITabBarItem(title: "SwiftUI", image: UIImage(systemName: "swift"), tag: 1)
        
        tabBar.viewControllers = [uiKitVC, swiftUIC]
        window.rootViewController = tabBar
        window.makeKeyAndVisible()
        
        return true
    }
}

