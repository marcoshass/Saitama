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
    
// mapstart
    let startLatitude: CLLocationDegrees = 35.7090259
    let startLongitude: CLLocationDegrees = 139.7319925
    let latitudinalMeters: CLLocationDistance = 800
    let longitudinalMeters: CLLocationDistance = 800
    let spanLongitudeDelta: CLLocationDegrees = 0.300
    let spanLatitudeDelta: CLLocationDegrees = 0.300
    
    var didTapLogout: () -> () = {}
    var didTapMyOrders: () -> () = {}
    
// logoutbutton
    lazy var logoutButtonItem : UIBarButtonItem = {
        let button = UIBarButtonItem(title: NSLocalizedString("Signout", comment: "Signout"), style: .plain, target: self, action: #selector(self.handleLogout))
        return button
    }()
    
// myorders
    lazy var myOrdersButtonItem : UIBarButtonItem = {
        let button = UIBarButtonItem(title: NSLocalizedString("MyOrders", comment: "MyOrders"), style: .plain, target: self, action: #selector(self.handlePayment))
        return button
    }()
    
// mapview
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
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
        
        setupStart()
        reloadData()
    }
    
    func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem = logoutButtonItem
        self.navigationItem.rightBarButtonItem = myOrdersButtonItem
    }

    // MARK: - MapKit
    
    func setupStart() {
        let startCoord = CLLocationCoordinate2D(latitude: startLatitude, longitude: startLongitude)
        var adjustedRegion = MKCoordinateRegionMakeWithDistance(startCoord, latitudinalMeters, longitudinalMeters)
        adjustedRegion.span.longitudeDelta = spanLongitudeDelta
        adjustedRegion.span.latitudeDelta = spanLatitudeDelta
        self.mapView.setRegion(adjustedRegion, animated: true)
    }
    
    func reloadData() {
        let allAnnotations = mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        WebService().load(Place.all(), completion: { (data, error) in
            DispatchQueue.main.async {
                if let error = error {
                    self.show(message: error.message())
                    return
                }
                
                guard let data = data else {
                    return
                }

                self.addPlaces(data)
            }
        })
    }
    
    func addPlaces(_ places: [Place]) {
        for place in places {
            guard let name = place.name, let lat = place.location?.lat, let lng = place.location?.lng else { continue }
            self.mapView.addAnnotation(BikePlace(title: name, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng)))
        }
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
