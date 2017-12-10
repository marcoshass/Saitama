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
    let msgProvideUser = NSLocalizedString("User must be provided to rent a bike", comment: "")
    let msgProvidePlace = NSLocalizedString("Place must be provided to rent a bike", comment: "")
    
    var didTapPay: ()->() = {}
    
    // Variables needed to rent a bike
    var place: Place?
    var user: User?
    
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
        weak var weakSelf = self
        let button = UIBarButtonItem(title: NSLocalizedString("Pay", comment: ""), style: .plain, target: weakSelf, action: #selector(weakSelf?.handlePay))
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = myTitle
        updateWidthsForLabels(labels: self.labels)
        setupViews()
        loadPlace()
    }
    
    func loadPlace() {
        guard let placeId = place?.id, let placeName = place?.name else { return }
        idTextField.text = placeId
        placeNameTextField.text = placeName
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
        guard let _ = user else { return msgProvideUser }
        guard let _ = place?.id, let _ = place?.name else { return msgProvidePlace }
        
        guard let number = cardNumberTextField.text,
            let name = cardNameTextField.text,
            let cvv = cvvTextField.text,
            let expiryMonth = expiryMonthTextField.text,
            let expiryYear = expiryYearTextField.text else {
                return NSLocalizedString("Check fields", comment: "")
        }

        if number.count == 0 ||
            name.count == 0 ||
            cvv.count == 0 ||
            expiryMonth.count == 0 ||
            expiryYear.count == 0 {
            return NSLocalizedString("Fields cannot be empty", comment: "")
        }

        return nil
    }
    
    func processPayment() {
        if let msg = validateFields() {
            self.show(message: msg)
            return
        }
        
        let card = Card(number: cardNumberTextField.text, name: cardNameTextField.text, cvv: cvvTextField.text, expiryMonth: expiryMonthTextField.text, expiryYear: expiryYearTextField.text)
  
        guard let user = user else {
            self.show(message: msgProvideUser)
            return
        }
        
        guard let placeId = place?.id else {
            self.show(message: msgProvidePlace)
            return
        }
        
        self.title = loadingTitle
        WebServiceNonLeak().load(user.rent(placeId: placeId, card: card), completion: { (data, error) in
            DispatchQueue.main.async {
                self.title = self.myTitle

                if let error = error {
                    self.show(message: error.message())
                    return
                }

                guard let _ = data else {
                    self.show(message: NSLocalizedString("Error, bike was not rent", comment: ""))
                    return
                }

                self.show(message: NSLocalizedString("Bike rent successfully", comment: ""), confirmHandler: {(action) in
                    self.didTapPay()
                })
            }
        })
    }
    
    // MARK: - Handlers
    
    // Enable action only if all fields were filled
    func handleInputText(_ sender: Any) {
        payButtonItem.isEnabled =
            idTextField.text?.count ?? 0 > 0 &&
            placeNameTextField.text?.count ?? 0 > 0 &&
            cardNumberTextField.text?.count ?? 0 > 0 &&
            cardNameTextField.text?.count ?? 0 > 0 &&
            cvvTextField.text?.count ?? 0 > 0 &&
            expiryMonthTextField.text?.count ?? 0 > 0 &&
            expiryYearTextField.text?.count ?? 0 > 0
    }
    
    func handlePay(_ sender: Any) {
        view.endEditing(true)
        processPayment()
    }
    
}
