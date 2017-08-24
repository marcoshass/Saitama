//
//  MyOrdersController.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 24/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import UIKit

class PaymentsController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    let payments: [Payment] = {
        let p1 = Payment(updatedAt: "2016-12-23T19:32:59.144Z", createdAt: "2016-12-23T19:32:59.144Z", creditCard: nil, email: "adrianobragaalencar@gmail.com", placeId: "45c0b5209973fcec652817e16e20f1d0b4ecb602")
        
        let p2 = Payment(updatedAt: "2016-12-23T19:33:25.497Z", createdAt: "2016-12-23T19:33:25.497Z", creditCard: nil, email: "adrianobragaalencar@gmail.com", placeId: "45c0b5209973fcec652817e16e20f1d0b4ecb602")
        
        return [p1]
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: self.view.frame.width, height: 10.0)
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.register(PaymentCell.self, forCellWithReuseIdentifier: self.cellId)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("My Orders", comment: "My Orders")
        view.backgroundColor = .white

        setupViews()
    }
    
    func setupViews() {
        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return payments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PaymentCell
        cell.payment = payments[indexPath.item]
        cell.contentView.translatesAutoresizingMaskIntoConstraints = false
        return cell
    }
    
}

