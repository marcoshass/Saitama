//
//  User.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import Foundation

private let PAYMENTS = "payments"
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
    
    init(email: String?, token: String) {
        self.id = nil
        self.email = email
        self.password = nil
        self.token = token
    }
}

extension User {

    static func login(email: String, password: String) -> Resource<User> {
        let url = URL(string: "http://www.mocky.io/v2/599e0f552500009705d303b2")!
        let dictionary = ["\(EMAIL)": email, "\(PASSWORD)": password]
        return Resource(url: url, method: .post(dictionary as AnyObject), parseJSON: { (json) -> User? in
            guard let dictionary = json as? JSONDictionary else { return nil }
            return User(dictionary: dictionary)
        })
    }
    
    static func register(user: User) -> Resource<User> {
        let url = URL(string: "http://www.mocky.io/v2/599e3560250000f406d303d2")!
        let dictionary = ["\(EMAIL)": user.email, "\(PASSWORD)": user.password]
        return Resource(url: url, method: .put(dictionary as AnyObject), parseJSON: { (json) -> User? in
            guard let dictionary = json as? JSONDictionary else { return nil }
            return User(dictionary: dictionary)
        })
    }

    /** Retrieves all payments placed by the user with the authentication token */
    func allPayments() -> Resource<[Payment]> {
        let url = URL(string: "http://www.mocky.io/v2/599ed8232c00004e0051d3cb")!
        return Resource(url: url, headers: [self.token ?? "": AUTHORIZATIONHEADER], parseJSON: { (json) -> [Payment]? in
            guard let dictionaries = json as? JSONDictionary else { return nil }
            guard let payments = dictionaries[PAYMENTS] as? [JSONDictionary] else { return nil }
            return payments.flatMap{Payment(dictionary: $0)}
        })
    }
    
    /** Place an order for bike rental, the parameters will be sent in the url */
    func rent(placeId: String, card: Card) -> Resource<User> {
        // append placeId
        var params = card.toHttpParams()
        params["placeId"] = placeId
        
        let baseUrl = URL(string: "http://www.mocky.io/v2/59a0b0f111000010066442b5")!
        let url = baseUrl.withParams(params: params)!
        print("card_url=\(url)")
        return Resource(url: url, method: .put([:] as AnyObject), parseJSON: { (json) -> User? in
            guard let dictionary = json as? JSONDictionary else { return nil }
            return User(dictionary: dictionary)
        })
    }
    
}

extension URL {
    
    /** Build a url with the parameters received */
    func withParams(params: HttpParameters) -> URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return nil }
        components.queryItems = params.map { URLQueryItem(name: String($0), value: String($1)) }
        return components.url
    }
    
}
