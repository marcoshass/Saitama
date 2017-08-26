//
//  Card.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 24/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import Foundation

private let NUMBER = "number"
private let NAME = "name"
private let CVV = "cvv"
private let EXPIRYMONTH = "expiryMonth"
private let EXPIRYYEAR = "expiryYear"

struct Card {
    let number: String?
    let name: String?
    let cvv: String?
    let expiryMonth: String?
    let expiryYear: String?
}

extension Card {
    init?(dictionary: JSONDictionary) {
        self.number = dictionary[NUMBER] as? String
        self.name = dictionary[NAME] as? String
        self.cvv = dictionary[CVV] as? String
        self.expiryMonth = dictionary[EXPIRYMONTH] as? String
        self.expiryYear = dictionary[EXPIRYYEAR] as? String
    }
}

extension Card {
    
    static func format(_ input: String) -> String {
        var formatted = ""
        var formatted4 = ""
        for character in input.characters {
            if formatted4.characters.count == 4 {
                formatted += formatted4 + " "
                formatted4 = ""
            }
            formatted4.append(character)
        }
        
        formatted += formatted4
        return formatted
    }
    
    /**
     Put the card into a dictionary for the rent service url
     */
    func toHttpParams() -> HttpParameters {
        let result: HttpParameters = [NUMBER: self.number ?? "", NAME: self.name ?? "", CVV: self.cvv ?? "", EXPIRYMONTH: self.expiryMonth ?? "", EXPIRYYEAR: self.expiryYear ?? ""]
        return result
    }
}
