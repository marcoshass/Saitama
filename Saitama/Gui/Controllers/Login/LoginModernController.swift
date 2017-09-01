//
//  LoginModern.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 01/09/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import UIKit

class LoginModernController: BaseController {

    // MARK: - Properties
    
    var didTapLogin: (Bool, User)->() = {_ in }
    var didTapCreate: ()->() = {}
    
// joinnow
    lazy var joinNowLabel: UILabel = {
        let label = UILabel()
        label.layer.borderColor = UIColor.blue.cgColor
        label.layer.borderWidth = 0.5
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium)
        label.textColor = .orange
        label.text = NSLocalizedString("JOIN NOW", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        view.backgroundColor = .clear
        
        view.addSubview(joinNowLabel)
        
        setupContainerView()
    }
    
    func setupContainerView() {
        joinNowLabel.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 22).isActive = true
        joinNowLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
    }
    
}

