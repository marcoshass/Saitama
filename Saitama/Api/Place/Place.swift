//
//  Place.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import Foundation

private let PLACES = "places"
private let UPDATEDAT = "updatedAt"
private let CREATEDAT = "createdAt"
private let ID = "id"
private let NAME = "name"
private let LOCATION = "location"

struct Place {
    var updatedAt: Date?
    var createdAt: Date?
    let id: String?
    let name: String?
    var location: Location?
}

extension Place {
    init?(dictionary: JSONDictionary) {
        if let updatedAt = dictionary[UPDATEDAT] as? String { self.updatedAt = Format.utc.date(from: updatedAt) }
        if let createdAt = dictionary[CREATEDAT] as? String { self.createdAt = Format.utc.date(from: createdAt) }
        self.id = dictionary[ID] as? String
        self.name = dictionary[NAME] as? String
        if let dict = dictionary[LOCATION] as? JSONDictionary { self.location = Location(dictionary: dict) }
    }
}

extension Place {
    
    /** Retrieves all places where bikes can be rent, auth token not needed */
    static func all() -> Resource<[Place]> {
//      let url = URL(string: "http://www.mocky.io/v2/599f29ea2c0000820151d480")!   // https://localhost:3000/places/ (GET)
        let url = URL(string: URLManager.places.url)!
        return Resource(url: url, parseJSON: { (json) -> [Place]? in
            guard let dictionaries = json as? JSONDictionary else { return nil }
            guard let places = dictionaries[PLACES] as? [JSONDictionary] else { return nil }
            return places.flatMap{Place(dictionary: $0)}
        })
    }
    
}
