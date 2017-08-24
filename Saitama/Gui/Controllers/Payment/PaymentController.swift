//
//  PaymentController.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import UIKit

class PaymentController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expirationLabel: UILabel!
    @IBOutlet weak var expirationTextField: UITextField!
    @IBOutlet weak var cvvLabel: UILabel!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var address1Label: UILabel!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2Label: UILabel!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var postalCodeLabel: UILabel!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countyLabel: UILabel!
    @IBOutlet weak var countyTextField: UITextField!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var areaCodeLabel: UILabel!
    @IBOutlet weak var areaCodeTextField: UITextField!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    
    // paymentbutton
    lazy var payButtonItem : UIBarButtonItem = {
        let button = UIBarButtonItem(title: NSLocalizedString("Pay", comment: "Pay"), style: .plain, target: self, action: #selector(self.handlePay))
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateWidthsForLabels(labels: self.labels)
        setupViews()
    }
    
    func setupViews() {
        setupNavigationBar()
        
        // adjust handlers
        nameTextField.addTarget(self, action: #selector(handleInputText), for: .editingChanged)
        surnameTextField.addTarget(self, action: #selector(handleInputText), for: .editingChanged)
        cardNumberTextField.addTarget(self, action: #selector(handleInputText), for: .editingChanged)
        expirationTextField.addTarget(self, action: #selector(handleInputText), for: .editingChanged)
        cvvTextField.addTarget(self, action: #selector(handleInputText), for: .editingChanged)
        address1TextField.addTarget(self, action: #selector(handleInputText), for: .editingChanged)
        address2TextField.addTarget(self, action: #selector(handleInputText), for: .editingChanged)
        postalCodeTextField.addTarget(self, action: #selector(handleInputText), for: .editingChanged)
        cityTextField.addTarget(self, action: #selector(handleInputText), for: .editingChanged)
        countyTextField.addTarget(self, action: #selector(handleInputText), for: .editingChanged)
        countryTextField.addTarget(self, action: #selector(handleInputText), for: .editingChanged)
        areaCodeTextField.addTarget(self, action: #selector(handleInputText), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(handleInputText), for: .editingChanged)
    }
    
    func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = payButtonItem
    }
    
    // MARK: - MainLogic
    
    func toggleFields() {
        //        closeButtonItem.isEnabled = !closeButtonItem.isEnabled
    }
    
    func toggleStart() {
        toggleFields()
        //        paymentIndicator.startAnimating()
    }
    
    func toggleStop() {
        toggleFields()
        //        paymentIndicator.stopAnimating()
    }
    
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
        
        //        let newUser = User(id: 0, name: nameTextField.text, email: emailTextField.text, password: passwordTextField.text, token: "\(nameTextField.text!)\(generateToken(newTokenLength))")
        //
        //        toggleStart()
        //        WebService().load(User.register(user: newUser), completion: { (user, error) in
        //            DispatchQueue.main.async{
        //                self.toggleStop()
        //
        //                if error != nil {
        //                    self.show(message: error?.localizedDescription ?? NSLocalizedString("Internal Error", comment: "Internal Error"))
        //                    print("error=\(error.debugDescription)")
        //                    return
        //                }
        //
        //                guard let _ = user else {
        //                    self.show(message: NSLocalizedString("Error registering user", comment: "Error registering user"))
        //                    return
        //                }
        //
        //                self.show(message: NSLocalizedString("User registered successfully", comment: "User registered successfully"), actionHandler: {(action) in
        //                    self.didTapRegister()
        //                })
        //            }
        //        })
    }
    
    // MARK: - Handlers
    func handleInputText(_ sender: Any) {
        payButtonItem.isEnabled =
            nameTextField.text?.characters.count ?? 0 > 0 &&
            surnameTextField.text?.characters.count ?? 0 > 0 &&
            cvvTextField.text?.characters.count ?? 0 > 0 &&
            address1TextField.text?.characters.count ?? 0 > 0 &&
            postalCodeTextField.text?.characters.count ?? 0 > 0 &&
            cityTextField.text?.characters.count ?? 0 > 0
    }
    
    func handlePay(_ sender: Any) {
        view.endEditing(true)
        processPayment()
    }
    
}
