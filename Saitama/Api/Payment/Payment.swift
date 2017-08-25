//
//  Payment.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import Foundation

private let UPDATEDAT = "updatedAt"
private let CREATEDAT = "createdAt"
private let CREDITCARD = "creditCard"
private let CARDNUMBER = "email"
private let PLACEID = "placeId"

struct Payment {
    var updatedAt: Date?
    var createdAt: Date?
    var creditCard: Card?
    let email: String?
    let placeId: String?
}

extension Payment {
    init?(dictionary: JSONDictionary) {
        if let updatedAt = dictionary[UPDATEDAT] as? String { self.updatedAt = Format.utc.date(from: updatedAt) }
        if let createdAt = dictionary[CREATEDAT] as? String { self.createdAt = Format.utc.date(from: createdAt) }
        if let dict = dictionary[CREDITCARD] as? JSONDictionary { self.creditCard = Card(dictionary: dict) }
        self.email = dictionary[CARDNUMBER] as? String
        self.placeId = dictionary[PLACEID] as? String
    }
}

