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
    
    var user: User? {
        didSet {
            guard let email = user?.email, let token = user?.token else { return }
            print("found in keychain: user=\(email) token(5 digits)=\(String(token.characters.prefix(5)))")
        }
    }
    
    init(window: UIWindow) {
        self.window = window
        
        let loginController = LoginController()
        loginController.didTapLogin = { (animate, user) in
            self.showMap(parent: loginController, animated: animate)
            self.user = user
        }
        
        loginController.didTapCreate = { self.showRegister(parent: loginController) }
        
        window.rootViewController = loginController
    }
    
    func showMap(parent: UIViewController, animated: Bool) {
        let mapController = MapController()
        mapController.didTapLogout = { self.dismiss(viewController: mapController) }
        mapController.didTapHistory = { self.showHistory(parent: mapController) }
        mapController.didTapRent = { (place) in self.showOrder(parent: mapController, place: place) }
        parent.present(UINavigationController(rootViewController: mapController), animated: animated, completion: nil)
    }
    
    func showRegister(parent: UIViewController) {
        let registerController = RegisterController()
        registerController.didTapRegister = { self.dismiss(viewController: registerController) }
        registerController.didTapAlreadyHaveAccount = { self.dismiss(viewController: registerController) }
        
        parent.present(UINavigationController(rootViewController:registerController), animated: true, completion: nil)
    }
    
    func showHistory(parent: UIViewController) {
        let paymentsController = PaymentsController()
        parent.navigationController?.pushViewController(paymentsController, animated: true)
    }
    
    func showOrder(parent: UIViewController, place: Place) {
        let orderController = UIStoryboard.init(name: orderStoryboard, bundle: nil).instantiateInitialViewController() as! OrderController
        orderController.place = place
        parent.navigationController?.pushViewController(orderController, animated: true)
    }
    
    func dismiss(viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
}

