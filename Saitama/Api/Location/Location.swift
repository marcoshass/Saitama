//
//  Location.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 24/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import Foundation

private let LAT = "lat"
private let LNG = "lng"

struct Location {
    let lat: String?
    let lng: String?
}

extension Location {
    init?(dictionary: JSONDictionary) {
        self.lat = dictionary[LAT] as? String
        self.lng = dictionary[LNG] as? String
    }
}
