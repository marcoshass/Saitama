//
//  MapController.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import UIKit
import KeychainAccess
import MapKit

class MapController: BaseController {
    
    // MARK: - Properties
    
    var didTapLogout: () -> () = {}
    var didTapMyOrders: () -> () = {}
    
    // logoutbutton
    lazy var logoutButtonItem : UIBarButtonItem = {
        let button = UIBarButtonItem(title: NSLocalizedString("Signout", comment: "Signout"), style: .plain, target: self, action: #selector(self.handleLogout))
        return button
    }()
    
    // myorders
    lazy var myOrdersButtonItem : UIBarButtonItem = {
        let button = UIBarButtonItem(title: NSLocalizedString("My Orders", comment: "My Orders"), style: .plain, target: self, action: #selector(self.handlePayment))
        return button
    }()
    
    // mapview
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    func reload() {
        //loadingIndicator.startAnimating()
        WebService().load(Place.all(), completion: { (data, error) in
            DispatchQueue.main.async {
                //self.loadingIndicator.stopAnimating()
                
                if let error = error {
                    self.show(message: error.message())
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                print(data)
                //self.payments = data
                //self.tableView.reloadData()
            }
        })
    }
    
    override func setupViews() {
        super.setupViews()
        self.title = NSLocalizedString("BikeMap", comment: "BikeMap")
        setupNavigationBar()
        view.backgroundColor = .white

        view.addSubview(mapView)
        
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem = logoutButtonItem
        self.navigationItem.rightBarButtonItem = myOrdersButtonItem
    }
    
    func processLogout() {
        let keychain = Keychain(service: Constants.Keychain.service)
        if !keychain.clear() {
            self.show(message: NSLocalizedString("Could not clear keychain", comment: "Could not clear keychain"))
        }
        didTapLogout()
    }
    
    // MARK: - Handlers
    
    func handleLogout(_ sender: Any) {
        let message = NSLocalizedString("Do you really want to signout?", comment: "Do you really want to signout?")
        let signout = NSLocalizedString("Signout", comment: "Signout")
        self.show(actionSet: .OkCancel, title: "", message: message, style: .actionSheet, confirmTitle: signout, confirmHandler: {(action) in
            self.processLogout()
        })
    }
    
    func handlePayment(_ sender: Any) {
        didTapMyOrders()
    }
    
}
