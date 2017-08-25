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

typealias PlaceDictionary = [String: String]

class MapController: BaseController, MKMapViewDelegate {
    
    // MARK: - Properties

    var didTapLogout: () -> () = {}
    var didTapHistory: (PlaceDictionary) -> () = {_ in}
    var didTapRent: (Place) -> () = {_ in}
    var selected: Place?

    // Dictionary to payments history
    var placeNames = PlaceDictionary()
    
// mapstart(saitama)
    let startLatitude: CLLocationDegrees = 35.7090259
    let startLongitude: CLLocationDegrees = 139.7319925
    let latitudinalMeters: CLLocationDistance = 800
    let longitudinalMeters: CLLocationDistance = 800
    let spanLongitudeDelta: CLLocationDegrees = 0.300
    let spanLatitudeDelta: CLLocationDegrees = 0.300

    
// logoutbutton
    lazy var logoutButtonItem : UIBarButtonItem = {
        let button = UIBarButtonItem(title: NSLocalizedString("Signout", comment: ""), style: .plain, target: self, action: #selector(self.handleLogout))
        return button
    }()
    
// historybutton
    lazy var historyButtonItem : UIBarButtonItem = {
        let button = UIBarButtonItem(title: NSLocalizedString("History", comment: ""), style: .plain, target: self, action: #selector(self.handleHistory))
        return button
    }()
    
// rentbutton
    lazy var rentButtonItem : UIBarButtonItem = {
        let button = UIBarButtonItem(title: NSLocalizedString("No place selected ", comment: ""), style: .plain, target: self, action: #selector(self.handleRent))
        button.setTitleTextAttributes(Constants.ToolbarButtonItem.textAttributes, for: .normal) // blue
        return button
    }()
    
// mapview
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    override func setupViews() {
        super.setupViews()
        view.backgroundColor = .white
        
        self.title = NSLocalizedString("BikeMap", comment: "")
        setupNavigationBar()
        setupToolbar()
        
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
        self.navigationItem.rightBarButtonItem = historyButtonItem
    }
    
    func setupToolbar() {
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.setToolbarItems([flex, flex, self.rentButtonItem], animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: false)
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
    
    /**
     Iterate over the places and place the annotations
     over the map. At the same time a dictionary with the
     place id and name will be fed to be sent to the payments
     history screen.
     */
    func addPlaces(_ places: [Place]) {
        // clear the map and dicionary
        let allAnnotations = mapView.annotations
        mapView.removeAnnotations(allAnnotations)
        placeNames.removeAll()
        
        for place in places {
            guard let id = place.id, let name = place.name, let lat = place.location?.lat, let lng = place.location?.lng else { continue }
            mapView.addAnnotation(BikePlace(title: name, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng), place: place))
            placeNames[id] = name
        }
    }
    
    func processLogout() {
        let keychain = Keychain(service: Constants.Keychain.service)
        if !keychain.clear() {
            self.show(message: NSLocalizedString("Could not clear keychain", comment: ""))
        }
        didTapLogout()
    }
    
    // MARK: - Handlers
    
    func handleLogout(_ sender: Any) {
        let message = NSLocalizedString("Do you really want to signout?", comment: "")
        let signout = NSLocalizedString("Signout", comment: "")
        self.show(actionSet: .OkCancel, title: "", message: message, style: .actionSheet, confirmTitle: signout, confirmHandler: {(action) in
            self.processLogout()
        })
    }
    
    func handleHistory(_ sender: Any) {
        didTapHistory(placeNames)
    }
    
    func handleRent(_ sender: Any) {
        guard let selected = selected else { self.show(message: NSLocalizedString("Pick a bike rental place on the map", comment: "")); return }
        self.didTapRent(selected)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let bikePlace = view.annotation as? BikePlace, let title = bikePlace.title else { return }
        selected = bikePlace.place
        let pickStr = NSLocalizedString("Rent at", comment: "")
        rentButtonItem.title = "\(pickStr): \(title)"
    }
    
}
