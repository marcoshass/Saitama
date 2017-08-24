//
//  BikePlace.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 24/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import Foundation
import MapKit

class BikePlace: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
