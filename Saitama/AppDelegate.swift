//
//  AppDelegate.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var navigation: NavigationManager?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        navigation = NavigationManager(window: window!)

        setupTheme()
        window?.makeKeyAndVisible()
        return true
    }
    
    func setupTheme() {
        // statusbar (+plist)
        UIApplication.shared.statusBarStyle = .lightContent
        
        // navigationbar
        UINavigationBar.appearance().barTintColor = Constants.Color.darkBlue
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = Constants.NavigationBar.textAttributes
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        
        // uitoolbar
        UIToolbar.appearance().backgroundColor = .white
        
        // uibarbuttonitem
        UIBarButtonItem.appearance().setTitleTextAttributes(Constants.UIBarButtonItem.enableTextAttributes, for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(Constants.UIBarButtonItem.disableTextAttributes, for: .disabled)
    }
    
}

