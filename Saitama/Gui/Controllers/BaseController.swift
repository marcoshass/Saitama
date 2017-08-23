//
//  BaseController.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import UIKit

class BaseController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    func handleBackgroundTap(_ send: UITapGestureRecognizer) {
        hideKeyboard(self)
    }
    
    func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
}
