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
    
    let payments: [Payment] = {
        
        let c1 = Card(number: "4111111111111111", name: "adrianobragaalencar", cvv: "123", expiryMonth: "03", expiryYear: "2100")
        let p1 = Payment(updatedAt: "2016-12-23T19:32:59.144Z", createdAt: "2016-12-23T19:32:59.144Z", creditCard: c1, email: "adrianobragaalencar@gmail.com", placeId: "45c0b5209973fcec652817e16e20f1d0b4ecb602")

        let c2 = Card(number: "4111111111111111", name: "adrianobragaalencar", cvv: "123", expiryMonth: "12", expiryYear: "2020")
        let p2 = Payment(updatedAt: "2016-12-23T19:33:25.497Z", createdAt: "2016-12-23T19:33:25.497Z", creditCard: c2, email: "adrianobragaalencar@gmail.com", placeId: "45c0b5209973fcec652817e16e20f1d0b4ecb60245c0b5209973fcec652817e16e20f1d0b4ecb60245c0b5209973fcec652817e16e20f1d0b4ecb60245c0b5209973fcec652817e16e20f1d0b4ecb60245c0b5209973fcec652817e16e20f1d0b4ecb60245c0b5209973fcec652817e16e20f1d0b4ecb60245c0b5209973fcec652817e16e20f1d0b4ecb60245c0b5209973fcec652817e16e20f1d0b4ecb60245c0b5209973fcec652817e16e20f1d0b4ecb60245c0b5209973fcec652817e16e20f1d0b4ecb602")
        
        return [p1, p2]
    }()

// tableview
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .white
        tv.dataSource = self
        tv.delegate = self
        tv.register(PaymentCell.self, forCellReuseIdentifier: self.cellId)
        tv.allowsSelection = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        // dynamic row height
        tv.rowHeight = UITableViewAutomaticDimension
        tv.estimatedRowHeight = 44
        tv.tableFooterView = UIView()
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("My Orders", comment: "My Orders")
        view.backgroundColor = .white

        setupViews()
    }
    
    func setupViews() {
        view.addSubview(tableView)

        tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
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

