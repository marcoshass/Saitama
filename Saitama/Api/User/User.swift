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
        let url = URL(string: "http://www.mocky.io/v2/599e0f552500009705d303b2")! // OK
//        let url = URL(string: "http://www.mocky.io/v2/599e11b8250000b405d303b5")! // user not found
//        let url = URL(string: "http://10.10.1.143:3000/users")! // Timeout        
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

    /**
     Retrieves all payments placed by the user with the authentication token
     */
    func all() -> Resource<[Payment]> {
        // let url = URL(string: "http://www.mocky.io/v2/59a0a3cb110000c9056442aa")! // Malformed Json (Tested)
        // let url = URL(string: "http://www.mocky.io/v2/59a0a313110000c0056442a9")! // Unauthorized (Tested)
        let url = URL(string: "http://www.mocky.io/v2/599ed8232c00004e0051d3cb")!
        return Resource(url: url, headers: [self.token ?? "": AUTHORIZATIONHEADER], parseJSON: { (json) -> [Payment]? in
            guard let dictionaries = json as? JSONDictionary else { return nil }
            guard let payments = dictionaries[PAYMENTS] as? [JSONDictionary] else { return nil }
            return payments.flatMap{Payment(dictionary: $0)}
        })
    }
    
}
