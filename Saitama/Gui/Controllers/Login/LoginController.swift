//
//  LoginController.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import UIKit
import KeychainAccess

class LoginController: BaseController, UITextFieldDelegate {
    
    // MARK: - Properties
    let keychain = Keychain(service: Constants.Keychain.service)
    
    var didTapLogin: (Bool) -> () = {_ in }
    var didTapForgot: () -> () = {}
    var didTapCreate: () -> () = {}
    
    // topconstraint
    var topViewConstraint: NSLayoutConstraint?
    let topHeightNormal: CGFloat = 180
    let topHeightKeyboard: CGFloat = 63
    
    // bottomconstraint
    var buttonConstraint: NSLayoutConstraint?
    let bottomHeightNormal: CGFloat = -16
    let bottomHeightKeyboard: CGFloat = -232
    
    // topview
    lazy var topLogoView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.darkBlue
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // container
    lazy var containerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 3
        view.layer.borderColor = Constants.Color.lightGray.cgColor
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // email
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.placeholder = NSLocalizedString("Email", comment: "Email")
        textField.text = "crossover@crossover.com"
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(handleInputText), for: .editingChanged)
        textField.delegate = self
        textField.returnKeyType = .next
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // divider1
    lazy var containerDividerView: UIView = {
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
        textField.placeholder = NSLocalizedString("Password", comment: "Password")
        textField.text = "crossover"
        textField.isSecureTextEntry = true
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(handleInputText), for: .editingChanged)
        textField.delegate = self
        textField.returnKeyType = .go
        textField.enablesReturnKeyAutomatically = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // loginbutton
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)
        button.layer.cornerRadius = 3
        button.backgroundColor = Constants.Color.darkBlue
        button.setTitle(NSLocalizedString("Login", comment: "Login"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(Constants.Color.disableBlue, for: .disabled)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // activitylogin
    let loginIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activity.hidesWhenStopped = true
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    // forgotlabel
    lazy var forgotPasswordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightSemibold)
        label.text = NSLocalizedString("Forgot password?", comment: "Forgot password?")
        label.textColor = Constants.Color.darkBlue
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleForgot)))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // divider2
    lazy var createDividerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.blue.cgColor
        view.layer.borderColor = Constants.Color.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // createlabel
    lazy var createAccountLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium)
        label.text = "OR"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // createbutton
    lazy var createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 1
        button.layer.borderColor = Constants.Color.darkBlue.cgColor
        button.backgroundColor = .clear
        button.setTitle(NSLocalizedString("Create new account", comment: "Create new account"), for: .normal)
        button.setTitleColor(Constants.Color.darkBlue, for: .normal)
        button.addTarget(self, action: #selector(handleCreateAccount), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isLoggedIn() {
            self.didTapLogin(false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterForKeyboardNotifications()
    }
    
    // MARK: - Layout
    
    override var shouldAutorotate: Bool {
        get {
            return false
        }
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func deregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // Avoid login button being covered by keyboard
    func keyboardWillShow(notification: Notification) {
        topViewConstraint?.constant = topHeightKeyboard
        buttonConstraint?.constant = bottomHeightKeyboard
        
        createDividerView.isHidden = true
        createAccountLabel.isHidden = true
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    // Restore controls to original position
    func keyboardWillHide(notification: Notification) {
        topViewConstraint?.constant = topHeightNormal
        buttonConstraint?.constant = bottomHeightNormal
        
        self.createDividerView.isHidden = false
        self.createAccountLabel.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }) { (completion) in
            self.createDividerView.isHidden = false
            self.createAccountLabel.isHidden = false
        }
    }
    
    override func setupViews() {
        super.setupViews()
        view.backgroundColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap)))
        
        view.addSubview(topLogoView)
        view.addSubview(containerView)
        view.addSubview(loginButton)
        view.addSubview(loginIndicator)
        view.addSubview(forgotPasswordLabel)
        
        view.addSubview(createDividerView)
        view.addSubview(createAccountLabel)
        view.addSubview(createAccountButton)
        
        setupContainerView()
    }
    
    func setupContainerView() {
        // topview + saved constraint
        topLogoView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topLogoView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topLogoView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topViewConstraint = topLogoView.heightAnchor.constraint(equalToConstant: topHeightNormal)
        topViewConstraint?.isActive = true
        
        containerView.addSubview(emailTextField)
        containerView.addSubview(containerDividerView)
        containerView.addSubview(passwordTextField)
        
        containerView.topAnchor.constraint(equalTo: topLogoView.bottomAnchor, constant: 32).isActive = true
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 85).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 1).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -12).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        containerDividerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        containerDividerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        containerDividerView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        containerDividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -12).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 42).isActive = true
        passwordTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -1).isActive = true
        
        loginButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 12).isActive = true
        loginButton.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        loginButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        loginIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor).isActive = true
        loginIndicator.rightAnchor.constraint(equalTo: loginButton.rightAnchor, constant: -16).isActive = true
        
        forgotPasswordLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20).isActive = true
        forgotPasswordLabel.leftAnchor.constraint(equalTo: loginButton.leftAnchor).isActive = true
        forgotPasswordLabel.rightAnchor.constraint(equalTo: loginButton.rightAnchor).isActive = true
        
        createDividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        createDividerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 43).isActive = true
        createDividerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -43).isActive = true
        createDividerView.bottomAnchor.constraint(equalTo: createAccountButton.topAnchor, constant: -27).isActive = true
        
        createAccountLabel.centerYAnchor.constraint(equalTo: createDividerView.centerYAnchor, constant: 0).isActive = true
        createAccountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createAccountLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        createAccountButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        createAccountButton.leftAnchor.constraint(equalTo: loginButton.leftAnchor).isActive = true
        createAccountButton.rightAnchor.constraint(equalTo: loginButton.rightAnchor).isActive = true
        
        // save bottom constraint for modification
        buttonConstraint = createAccountButton.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor, constant: bottomHeightNormal)
        buttonConstraint?.isActive = true
    }
    
    // MARK: - MainLogic
    
    func toggleFields() {
        emailTextField.isEnabled = !emailTextField.isEnabled
        passwordTextField.isEnabled = !passwordTextField.isEnabled
        loginButton.isEnabled = !loginButton.isEnabled
        forgotPasswordLabel.isUserInteractionEnabled = !forgotPasswordLabel.isUserInteractionEnabled
        createAccountButton.isEnabled = !createAccountButton.isEnabled
    }
    
    func toggleStart() {
        toggleFields()
        loginIndicator.startAnimating()
    }
    
    func toggleStop() {
        toggleFields()
        loginIndicator.stopAnimating()
    }
    
    func processLogin() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {
                self.show(message: NSLocalizedString("Credentials cannot be empty", comment: "Credentials cannot be empty"))
                return
        }
        
        toggleStart()
        WebService().load(User.login(email: email, password: password), completion: { (users, error) in
            OperationQueue.main.addOperation({
                self.toggleStop()
                
                if error != nil {
                    self.show(message: error?.localizedDescription ?? NSLocalizedString("Internal Error", comment: "Internal Error"))
                    print("error=\(error.debugDescription)")
                    return
                }
                
                guard let users = users, !users.isEmpty else {
                    self.show(message: NSLocalizedString("Invalid user or password", comment: "Invalid user or password"))
                    return
                }
                
                // check info needed for token
                let user = users[0]
                guard let email = user.email, let token = user.token else {
                    self.show(message: NSLocalizedString("Invalid email or token", comment: "Invalid email or token"))
                    return
                }
                
                // write token to keychain
                if self.keychain.persist(token: token, email: email) {
                    self.didTapLogin(true)
                } else {
                    self.show(message: NSLocalizedString("Could not persist token", comment: "Could not persist token"))
                }
            })
        })
    }
    
    func isLoggedIn() -> Bool {
        return !keychain.isEmpty()
    }
    
    // MARK: - Handlers
    
    func handleLogin(_ sender: Any) {
        processLogin()
    }
    
    func handleForgot(_ sender: UITapGestureRecognizer) {
        didTapForgot()
    }
    
    func handleCreateAccount(_ sender: Any) {
        didTapCreate()
    }
    
    func handleInputText() {
        loginButton.isEnabled =
            emailTextField.text?.characters.count ?? 0 > 0 &&
            passwordTextField.text?.characters.count ?? 0 > 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        
        if textField == passwordTextField {
            processLogin()
            passwordTextField.resignFirstResponder()
        }
        
        return true
    }
    
}
