//
//  NavigationManager.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import UIKit

class NavigationManager {
    
    let orderStoryboard = "Order"
    let window: UIWindow
    
    // User for view controller that require auth
    var user: User? {
        didSet {
            guard let email = user?.email, let token = user?.token else { return }
            print("NavigationManager: user=\(email) token(5 digits)=\(String(token.characters.prefix(5)))")
        }
    }
    
    init(window: UIWindow) {
        self.window = window
        let loginController = LoginController()
        
        // The current user is saved into the navigation manager
        // and will send the user to the view controllers that
        // require the authentication token
        loginController.didTapLogin = { (animate, user) in
            self.showMap(parent: loginController, animated: animate)
            self.user = user
        }
        
        loginController.didTapCreate = { self.showRegister(parent: loginController) }
        window.rootViewController = loginController
    }

// unauthenticated
    
    /**
     MapController (does not require token)
     */
    func showMap(parent: UIViewController, animated: Bool) {
        let mapController = MapController()
        mapController.didTapLogout = { self.dismiss(viewController: mapController) }
        
        // Send the dictionary with the places to payments history viewcontroller
        mapController.didTapHistory = { (places) in
            self.showHistory(parent: mapController, places: places)
        }
        mapController.didTapRent = { (place) in self.showOrder(parent: mapController, place: place) }
        parent.present(UINavigationController(rootViewController: mapController), animated: animated, completion: nil)
    }
    
    /**
     RegisterController (does not require token)
     */
    func showRegister(parent: UIViewController) {
        let registerController = RegisterController()
        registerController.didTapRegister = { self.dismiss(viewController: registerController) }
        registerController.didTapAlreadyHaveAccount = { self.dismiss(viewController: registerController) }
        
        parent.present(UINavigationController(rootViewController:registerController), animated: true, completion: nil)
    }

// requiresauthentication
    
    /**
     PaymentsController (requires authentication token)
     */
    func showHistory(parent: UIViewController, places: PlaceDictionary) {
        guard let user = user else { return }
        let paymentsController = PaymentsController(user: user, places: places)
        parent.navigationController?.pushViewController(paymentsController, animated: true)
    }
    
    /**
     OrderController (requires authentication token)
     */
    func showOrder(parent: UIViewController, place: Place) {
        let orderController = UIStoryboard.init(name: orderStoryboard, bundle: nil).instantiateInitialViewController() as! OrderController
        orderController.place = place
        parent.navigationController?.pushViewController(orderController, animated: true)
    }

// utility
    
    func dismiss(viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
}

