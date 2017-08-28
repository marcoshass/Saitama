//: Playground - noun: a place where people can play

import Foundation
import PlaygroundSupport

typealias JSONDictionary = [String: AnyObject]

// ----------------------------------------------------------------------------
// User
// ----------------------------------------------------------------------------

private let ID = "id"
private let EMAIL = "email"
private let PASSWORD = "password"
private let TOKEN = "token"

struct User {
    let id: Int?
    var email: String?
    let password: String?
    let token: String?
}

extension User {
    init?(dictionary: JSONDictionary) {
        self.id = dictionary[ID] as? Int
        self.email = dictionary[EMAIL] as? String
        self.password = dictionary[PASSWORD] as? String
        self.token = dictionary[TOKEN] as? String
    }
    
    init(email: String?, password: String?) {
        self.id = nil
        self.email = email
        self.password = password
        self.token = nil
    }
}

// ----------------------------------------------------------------------------
// Card
// ----------------------------------------------------------------------------

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
}


// ----------------------------------------------------------------------------
// Payment
// ----------------------------------------------------------------------------

private let UPDATEDAT = "updatedAt"
private let CREATEDAT = "createdAt"
private let CREDITCARD = "creditCard"
private let CARDNUMBER = "email"
private let PLACEID = "placeId"

struct Payment {
    let updatedAt: String?
    let createdAt: String?
    var creditCard: Card?
    let email: String?
    let placeId: String?
}

extension Payment {
    init?(dictionary: JSONDictionary) {
        self.updatedAt = dictionary[UPDATEDAT] as? String
        self.createdAt = dictionary[CREATEDAT] as? String
        if let dict = dictionary[CREDITCARD] as? JSONDictionary {
            self.creditCard = Card(dictionary: dict)
        }
        self.email = dictionary[CARDNUMBER] as? String
        self.placeId = dictionary[PLACEID] as? String
    }
}

// ----------------------------------------------------------------------------
// Api
// ----------------------------------------------------------------------------


struct Resource {
    let url: URL
    let parseJSON: (JSONDictionary?)->[Payment]?
}

final class WebService {
    
    func load(resource: Resource, completion: @escaping ([Payment]?, Error?)->()) {
        URLSession.shared.dataTask(with: resource.url, completionHandler: {(data, response, error) in
            guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary else {
                completion(nil, error)
                return
            }
            completion(resource.parseJSON(json), error)
        }).resume()
    }
    
}

PlaygroundPage.current.needsIndefiniteExecution = true

let url = URL(string: "http://www.mocky.io/v2/599ed8232c00004e0051d3cb")!

extension Payment {
    
    static let all = Resource(url: url) { (json) in
        guard let json = json, let array = json["payments"] as? [JSONDictionary] else { return nil }
        return array.flatMap{Payment(dictionary: $0)}
    }
    
}

WebService().load(resource: Payment.all) { (payments, error) in
    guard let payments = payments else { return }
    print("payments=\(payments)")
}


