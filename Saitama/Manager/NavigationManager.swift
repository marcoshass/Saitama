//
//  NavigationManager.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import UIKit

class NavigationManager {
    
    let window: UIWindow
    let paymentStoryboard = "Payment"
    
    init(window: UIWindow) {
        self.window = window
        let loginController = LoginController()
        loginController.didTapLogin = { (animate) in self.showMap(parent: loginController, animated: animate) }
        loginController.didTapForgot = { self.showForgot(parent: loginController) }
        loginController.didTapCreate = { self.showRegister(parent: loginController) }
        
        window.rootViewController = loginController
    }
    
    func showMap(parent: UIViewController, animated: Bool) {
        let mapController = MapController()
        mapController.didTapLogout = { self.dismiss(viewController: mapController) }
        mapController.didTapPayment = { self.showPayment(parent: mapController) }
        
        parent.present(UINavigationController(rootViewController: mapController), animated: animated, completion: nil)
    }
    
    func showForgot(parent: UIViewController) {
        let forgotController = ForgotController()
        forgotController.didTapClose = { self.dismiss(viewController: forgotController) }
        parent.present(UINavigationController(rootViewController:forgotController), animated: true, completion: nil)
    }
    
    func showRegister(parent: UIViewController) {
        let registerController = RegisterController()
        registerController.didTapRegister = { self.dismiss(viewController: registerController) }
        registerController.didTapAlreadyHaveAccount = { self.dismiss(viewController: registerController) }
        
        parent.present(UINavigationController(rootViewController:registerController), animated: true, completion: nil)
    }
    
    func showPayment(parent: UIViewController) {
        guard let paymentController = UIStoryboard.init(name: paymentStoryboard, bundle: nil).instantiateInitialViewController() else { return }
        parent.navigationController?.pushViewController(paymentController, animated: true)
    }
    
    func dismiss(viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
}

