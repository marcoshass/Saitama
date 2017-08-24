//
//  MyOrdersController.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 24/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import UIKit

class PaymentsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellId = "cellId"
    var payments = [Payment]()

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

// activitylogin
    let loadingIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activity.hidesWhenStopped = true
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    func reload() {
        let user = User(id: 1, email: "marcoshass@gmail.com", password: "123", token: "123")

        loadingIndicator.startAnimating()
        WebService().load(Payment.all(user: user), completion: { (data, error) in
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
                
                if let error = error {
                    self.show(message: error.message())
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                self.payments = data
                self.tableView.reloadData()
            }
        })
    }
    
    func setupViews() {
        self.title = NSLocalizedString("My Orders", comment: "My Orders")
        setupNavigationBar()
        view.backgroundColor = .white
        view.addSubview(tableView)

        tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
    }
    
    func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: loadingIndicator)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PaymentCell
        cell.payment = payments[indexPath.item]
        return cell
    }
    
}

