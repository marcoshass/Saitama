//
//  MyOrdersController.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 24/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import UIKit

class PaymentsController: UIViewController, UITableViewDataSource, UITableViewDelegate {

// localization
    let cellId = "cellId"
    let myTitle = NSLocalizedString("History", comment: "")
    let loadingTitle = NSLocalizedString("Loading...", comment: "")

    var payments = [Payment]()

    // User and places must be sent to show the payments history
    let user: User
    let places: PlaceDictionary

// tableview
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .white
        tv.dataSource = self
        tv.delegate = self
        tv.register(PaymentCell.self, forCellReuseIdentifier: self.cellId)
        tv.allowsSelection = false
        tv.tableFooterView = UIView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        // dynamic row height
        tv.rowHeight = UITableViewAutomaticDimension
        tv.estimatedRowHeight = 44
        return tv
    }()
    
    init(user: User, places: PlaceDictionary) {
        self.user = user
        self.places = places
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    func reload() {
        self.title = loadingTitle
        WebServiceNonLeak().load(self.user.allPayments()) { (data, error) in
            DispatchQueue.main.async {
                self.title = self.myTitle

                if let error = error {
                    self.show(message: error.message())
                    return
                }

                guard let data = data else {
                    self.show(message: NSLocalizedString("No data returned", comment: "No data returned"))
                    return
                }
                
                self.payments = data
                self.tableView.reloadData()
            }
        }
    }
    
    func setupViews() {
        self.title = myTitle
        view.backgroundColor = .white
        view.addSubview(tableView)

        tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payments.count
    }

    // Set the payment data on the cell and the place name
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PaymentCell
        let payment = payments[indexPath.item]
        cell.setPayment(payment: payment, placeName: places[payment.placeId ?? ""])
        return cell
    }
    
}

