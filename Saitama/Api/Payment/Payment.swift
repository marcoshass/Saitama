//
//  Payment.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import Foundation

private let ID = "id"
private let NAME = "name"
private let SURNAME = "surname"
private let CARDNUMBER = "cardNumber"
private let EXPIRATION = "expiration"
private let CVV = "cvv"
private let ADDRESS1 = "address1"
private let ADDRESS2 = "address2"
private let POSTALCODE = "postalCode"
private let CITY = "city"
private let COUNTY = "county"
private let COUNTRY = "country"
private let AREACODE = "areaCode"
private let PHONE = "phone"

struct Card {
    let id: Int?
    let name: String?
    let surname: String?
    let cardNumber: String?
    let expiration: String?
    let cvv: String?
    let address1: String?
    let address2: String?
    let postalCode: String?
    let city: String?
    let county: String?
    let country: String?
    let areaCode: String?
    let phone: String?
}

extension Card {
    init?(dictionary: JSONDictionary) {
        self.id = dictionary[ID] as? Int
        self.name = dictionary[NAME] as? String
        self.surname = dictionary[SURNAME] as? String
        self.cardNumber = dictionary[CARDNUMBER] as? String
        self.expiration = dictionary[EXPIRATION] as? String
        self.cvv = dictionary[CVV] as? String
        self.address1 = dictionary[ADDRESS1] as? String
        self.address2 = dictionary[ADDRESS2] as? String
        self.postalCode = dictionary[POSTALCODE] as? String
        self.city = dictionary[CITY] as? String
        self.county = dictionary[COUNTY] as? String
        self.country = dictionary[COUNTRY] as? String
        self.areaCode = dictionary[AREACODE] as? String
        self.phone = dictionary[PHONE] as? String
    }
}

extension Card {
    static func insert(card: Card) -> Resource<Card> {
        let url = URL(string: "http://10.10.1.143:3000/cards")!
        let dictionary = ["\(NAME)": card.name, "\(SURNAME)": card.surname, "\(CARDNUMBER)": card.cardNumber, "\(EXPIRATION)": card.expiration, "\(CVV)": card.cvv, "\(ADDRESS1)": card.address1, "\(ADDRESS2)": card.address2, "\(POSTALCODE)": card.postalCode, "\(CITY)": card.city, "\(COUNTY)": card.county, "\(COUNTRY)": card.country, "\(AREACODE)": card.areaCode, "\(PHONE)": card.phone ]
        return Resource(url: url, method: .post(dictionary as AnyObject), parseJSON: { (json) -> Card? in
            guard let dictionary = json as? JSONDictionary else { return nil }
            return Card(dictionary: dictionary)
        })
    }
}
