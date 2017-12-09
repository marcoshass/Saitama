//
//  RegisterController.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import UIKit

class RegisterController: BaseController, UITextFieldDelegate {
    
    var didTapRegister: () -> () = {}
    var didTapAlreadyHaveAccount: () -> () = {}
    
    // closebutton
    lazy var closeButtonItem : UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = #imageLiteral(resourceName: "cross").withRenderingMode(.alwaysTemplate)
        button.target = self
        button.action = #selector(self.handleReturnToLogin)
        return button
    }()
    
    // container
    lazy var containerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 3
        view.layer.borderColor = Constants.Color.lightGray.cgColor
        view.backgroundColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // email
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.placeholder = NSLocalizedString("Email", comment: "")
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        textField.returnKeyType = .next
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // divider2
    lazy var divider2: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.blue.cgColor
        view.layer.borderColor = Constants.Color.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // password
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.placeholder = NSLocalizedString("Password", comment: "")
        textField.isSecureTextEntry = true
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        textField.returnKeyType = .next
        textField.enablesReturnKeyAutomatically = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // divider3
    lazy var divider3: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.blue.cgColor
        view.layer.borderColor = Constants.Color.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // confirmpassword
    lazy var confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.placeholder = NSLocalizedString("Confirm password", comment: "")
        textField.isSecureTextEntry = true
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        textField.returnKeyType = .go
        textField.enablesReturnKeyAutomatically = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // registerbutton
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 1
        button.layer.borderColor = Constants.Color.darkBlue.cgColor
        button.backgroundColor = .clear
        button.setTitle(NSLocalizedString("Register", comment: ""), for: .normal)
        button.setTitleColor(Constants.Color.darkBlue, for: .normal)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // activitylogin
    let registerIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activity.hidesWhenStopped = true
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    
    // returnlabel
    lazy var returnToLoginLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightSemibold)
        label.text = NSLocalizedString("Already have an account?", comment: "")
        label.textColor = Constants.Color.darkBlue
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleReturnToLogin)))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func setupViews() {
        super.setupViews()
        self.title = NSLocalizedString("Register Account", comment: "")
        setupNavigationBar()
        
        view.backgroundColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap)))
        view.addSubview(containerView)
        
        setupContainerView()
    }
    
    func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = closeButtonItem
    }
    
    func setupContainerView() {
        view.addSubview(emailTextField)
        view.addSubview(divider2)
        view.addSubview(passwordTextField)
        view.addSubview(divider3)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(registerButton)
        view.addSubview(registerIndicator)
        view.addSubview(returnToLoginLabel)
        
        containerView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 20).isActive = true
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 148).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 1).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -12).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 47).isActive = true
        
        divider2.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 0).isActive = true
        divider2.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        divider2.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        divider2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: divider2.bottomAnchor, constant: 0).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -12).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 47).isActive = true
        
        divider3.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 0).isActive = true
        divider3.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        divider3.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        divider3.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        confirmPasswordTextField.topAnchor.constraint(equalTo: divider3.bottomAnchor, constant: 0).isActive = true
        confirmPasswordTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        confirmPasswordTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -12).isActive = true
        confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 47).isActive = true
        
        registerButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20).isActive = true
        registerButton.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        registerButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        registerIndicator.centerYAnchor.constraint(equalTo: registerButton.centerYAnchor).isActive = true
        registerIndicator.rightAnchor.constraint(equalTo: registerButton.rightAnchor, constant: -16).isActive = true
        registerIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
        registerIndicator.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        returnToLoginLabel.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 14).isActive = true
        returnToLoginLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        returnToLoginLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
    }
    
    // MARK: - MainLogic
    
    func toggleFields() {
        closeButtonItem.isEnabled = !closeButtonItem.isEnabled
        emailTextField.isEnabled = !emailTextField.isEnabled
        passwordTextField.isEnabled = !passwordTextField.isEnabled
        confirmPasswordTextField.isEnabled = !confirmPasswordTextField.isEnabled
        registerButton.isEnabled = !registerButton.isEnabled
        returnToLoginLabel.isUserInteractionEnabled = !returnToLoginLabel.isUserInteractionEnabled
    }
    
    func toggleStart() {
        toggleFields()
        registerIndicator.startAnimating()
    }
    
    func toggleStop() {
        toggleFields()
        registerIndicator.stopAnimating()
    }
    
    func validateFields() -> String? {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text else {
                return NSLocalizedString("Check fields", comment: "")
        }
        
        if email.count == 0 || password.count == 0 {
            return NSLocalizedString("Fields cannot be empty", comment: "")
        }
        
        if !Email.isValid(email) {
            return NSLocalizedString("Invalid email address", comment: "")
        }
        
        if password != confirmPassword {
            return NSLocalizedString("Passwords don't match", comment: "")
        }
        
        return nil
    }
    
    func processRegister() {
        if let msg = validateFields() {
            self.show(message: msg)
            return
        }
        
        let newUser = User(email: emailTextField.text, password: passwordTextField.text)
        
        toggleStart()
        WebService().load(User.register(user: newUser), completion: { (user, error) in
            DispatchQueue.main.async {
                self.toggleStop()
                
                if let error = error {
                    self.show(message: error.message())
                    return
                }
                
                guard let user = user else {
                    self.show(message: NSLocalizedString("Error registering user", comment: ""))
                    return
                }
                
                // check token
                guard let _ = user.token else {
                    self.show(message: NSLocalizedString("Invalid token", comment: ""))
                    return
                }
                
                self.show(message: NSLocalizedString("User registered successfully", comment: ""), confirmHandler: {(action) in
                    self.didTapRegister()
                })
            }
        })
    }
    
    // MARK: - Handlers
    
    func handleRegister(_ sender: Any) {
        hideKeyboard(self)
        processRegister()
    }
    
    func handleReturnToLogin(_ sender: Any) {
        didTapAlreadyHaveAccount()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        
        if textField == passwordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        }
        
        if textField == confirmPasswordTextField {
            hideKeyboard(self)
            processRegister()
        }
        
        return true
    }
    
}
