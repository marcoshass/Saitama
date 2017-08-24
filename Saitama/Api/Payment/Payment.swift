//
//  Payment.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import Foundation

private let UPDATEDAT = "id"
private let CREATEDAT = "name"
private let CREDITCARD = "surname"
private let EMAIL = "cardNumber"
private let PLACEID = "expiration"

struct Payment {
    let updatedAt: String?
    let createdAt: String?
    let creditCard: Card?
    let email: String?
    let placeId: String?
}

extension Payment {
    init?(dictionary: JSONDictionary) {
        self.updatedAt = dictionary[UPDATEDAT] as? String
        self.createdAt = dictionary[CREATEDAT] as? String
        self.creditCard = dictionary[CREDITCARD] as? Card
        self.email = dictionary[EMAIL] as? String
        self.placeId = dictionary[PLACEID] as? String
    }
}

extension Payment {
    
    static func all(user: User) -> Resource<[Payment]> {
        let url = URL(string: "http://www.mocky.io/v2/599ed8232c00004e0051d3cb")!
        return Resource(url: url, parseJSON: { (json) -> [Payment]? in
            guard let dictionaries = json as? [JSONDictionary] else { return nil }
            return dictionaries.flatMap{Payment(dictionary: $0)}
        })
    }
    
}
