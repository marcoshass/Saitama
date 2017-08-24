//
//  MapController.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import UIKit
import KeychainAccess

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
//    lazy var mapView: GMSMapView = {
//        var camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
//        var map = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        map.isMyLocationEnabled = true
//        map.translatesAutoresizingMaskIntoConstraints = false
//        
//        // marker in the center.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = map
//        return map
//    }()
    
    override func setupViews() {
        super.setupViews()
        self.title = NSLocalizedString("BikeMap", comment: "BikeMap")
        setupNavigationBar()
        view.backgroundColor = .white
        //view.addSubview(mapView)
        
        setupContainerView()
    }
    
    func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem = logoutButtonItem
        self.navigationItem.rightBarButtonItem = myOrdersButtonItem
    }
    
    func setupContainerView() {
//        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        mapView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
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
