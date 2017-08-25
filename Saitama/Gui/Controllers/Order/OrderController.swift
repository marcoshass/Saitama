//
//  PaymentController.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import UIKit

class OrderController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    let myTitle = NSLocalizedString("Order", comment: "")
    let loadingTitle = NSLocalizedString("Renting...", comment: "")
    
    var place: Place?
    
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeNameTextField: UITextField!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardNameTextField: UITextField!
    @IBOutlet weak var cvvLabel: UILabel!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var expiryMonthLabel: UILabel!
    @IBOutlet weak var expiryMonthTextField: UITextField!
    @IBOutlet weak var expiryYearLabel: UILabel!
    @IBOutlet weak var expiryYearTextField: UITextField!
    
    // paymentbutton
    lazy var payButtonItem : UIBarButtonItem = {
        let button = UIBarButtonItem(title: NSLocalizedString("Pay", comment: ""), style: .plain, target: self, action: #selector(self.handlePay))
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = myTitle
        updateWidthsForLabels(labels: self.labels)
        setupViews()
        print("place=\(self.place?.name ?? "empty place")")
    }
    
    func setupViews() {
        setupNavigationBar()
        
        // setup handlers
        idTextField.addTarget(self, action: #selector(handleInputText), for: .editingChanged)
        placeNameTextField.addTarget(self, action: #selector(handleInputText), for: .editingChanged)
        cardNumberTextField.addTarget(self, action: #selector(handleInputText), for: .editingChanged)
        cardNameTextField.addTarget(self, action: #selector(handleInputText), for: .editingChanged)
        cvvTextField.addTarget(self, action: #selector(handleInputText), for: .editingChanged)
        expiryMonthTextField.addTarget(self, action: #selector(handleInputText), for: .editingChanged)
        expiryYearTextField.addTarget(self, action: #selector(handleInputText), for: .editingChanged)
    }
    
    func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = payButtonItem
    }
    
    // MARK: - MainLogic
    
    func validateFields() -> String? {
        // (msgBox)
        // códigddearea, telefone, numerocartao, vencimento, cvv
        
        //        guard let name = nameTextField.text,
        //            let email = emailTextField.text,
        //            let password = passwordTextField.text,
        //            let confirmPassword = confirmPasswordTextField.text else {
        //                return NSLocalizedString("Check fields", comment: "Check fields")
        //        }
        //
        //        if name.characters.count == 0 ||
        //            email.characters.count == 0 ||
        //            password.characters.count == 0 {
        //            return NSLocalizedString("Fields cannot be empty", comment: "Fields cannot be empty")
        //        }
        //
        //        if password != confirmPassword {
        //            return NSLocalizedString("Passwords don't match", comment: "Passwords don't match")
        //        }
        
        return nil
    }
    
    func processPayment() {
        if let msg = validateFields() {
            self.show(message: msg)
            return
        }
        
//        let newUser = User(email: emailTextField.text, password: passwordTextField.text)
//        
//        self.title = loadingTitle
//        WebService().load(User.register(user: newUser), completion: { (user, error) in
//            DispatchQueue.main.async {
//                self.title = myTitle
//                
//                if let error = error {
//                    self.show(message: error.message())
//                    return
//                }
//                
//                guard let user = user else {
//                    self.show(message: NSLocalizedString("Error registering user", comment: ""))
//                    return
//                }
//                
//                // check token
//                guard let _ = user.token else {
//                    self.show(message: NSLocalizedString("Invalid token", comment: ""))
//                    return
//                }
//                
//                self.show(message: NSLocalizedString("User registered successfully", comment: ""), confirmHandler: {(action) in
//                    self.didTapRegister()
//                })
//            }
//        })
    }
    
    // MARK: - Handlers
    
    // Enable action only if all fields were filled
    func handleInputText(_ sender: Any) {
        payButtonItem.isEnabled =
            idTextField.text?.characters.count ?? 0 > 0 &&
            placeNameTextField.text?.characters.count ?? 0 > 0 &&
            cardNumberTextField.text?.characters.count ?? 0 > 0 &&
            cardNameTextField.text?.characters.count ?? 0 > 0 &&
            cvvTextField.text?.characters.count ?? 0 > 0 &&
            expiryMonthTextField.text?.characters.count ?? 0 > 0 &&
            expiryYearTextField.text?.characters.count ?? 0 > 0
    }
    
    func handlePay(_ sender: Any) {
        view.endEditing(true)
        processPayment()
    }
    
}
