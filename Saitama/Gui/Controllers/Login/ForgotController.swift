//
//  ForgotController.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import UIKit

class ForgotController: BaseController, UITextFieldDelegate {
    
    var didTapClose: ()->() = {}
    
    // closebutton
    lazy var closeButtonItem : UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = #imageLiteral(resourceName: "cross").withRenderingMode(.alwaysTemplate)
        button.target = self
        button.action = #selector(self.handleReturnToLogin)
        return button
    }()
    
    // instructionslabel
    lazy var instructionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)
        label.text = NSLocalizedString("Type in your email for account recovery", comment: "Type in your email for account recovery")
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // emaillabel
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightLight)
        label.text = NSLocalizedString("Email", comment: "Email")
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // email
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)
        textField.textColor = UIColor.darkGray
        textField.placeholder = NSLocalizedString("example@example.com", comment: "example@example.com")
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.addTarget(self, action: #selector(handleInputText), for: .editingChanged)
        textField.delegate = self
        textField.returnKeyType = .next
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // divider1
    lazy var emailDividerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.blue.cgColor
        view.layer.borderColor = Constants.Color.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // sendmailbutton
    lazy var sendMailButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 1
        button.layer.borderColor = Constants.Color.darkBlue.cgColor
        button.backgroundColor = .clear
        button.setTitle(NSLocalizedString("Send email", comment: "Send email"), for: .normal)
        button.setTitleColor(Constants.Color.darkBlue, for: .normal)
        button.addTarget(self, action: #selector(handleSendMail), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override var shouldAutorotate: Bool {
        get {
            return false
        }
    }
    
    override func setupViews() {
        super.setupViews()
        self.title = NSLocalizedString("Forgot Password", comment: "Forgot Password")
        setupNavigationBar()
        
        view.backgroundColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap)))
        
        view.addSubview(instructionsLabel)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(emailDividerView)
        view.addSubview(sendMailButton)
        
        instructionsLabel.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 20).isActive = true
        instructionsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        instructionsLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        emailLabel.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 15).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 0).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        emailDividerView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 0).isActive = true
        emailDividerView.leftAnchor.constraint(equalTo: emailTextField.leftAnchor).isActive = true
        emailDividerView.rightAnchor.constraint(equalTo: emailTextField.rightAnchor).isActive = true
        emailDividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        sendMailButton.topAnchor.constraint(equalTo: emailDividerView.bottomAnchor, constant: 20).isActive = true
        sendMailButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sendMailButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        sendMailButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = closeButtonItem
    }
    
    func processReturnToLogin() {
        didTapClose()
    }
    
    // MARK: - Handlers
    
    func handleInputText() {
        //        loginButton.isEnabled =
        //            emailTextField.text?.characters.count ?? 0 > 0 &&
        //            passwordTextField.text?.characters.count ?? 0 > 0
    }
    
    func handleReturnToLogin(_ sender: Any) {
        hideKeyboard(self)
        processReturnToLogin()
    }
    
    func handleSendMail(_ sender: Any) {
        
    }
    
}
