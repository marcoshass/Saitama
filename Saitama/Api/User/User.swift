//
//  User.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import Foundation

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
}

extension User {
    static func login(email: String, password: String) -> Resource<[User]> {
        let url = URL(string: "http://10.10.1.143:3000/users?email=\(email)&password=\(password)")!
        return Resource(url: url, parseJSON: { (json) -> [User]? in
            guard let dictionaries = json as? [JSONDictionary] else { return nil }
            return dictionaries.flatMap{User(dictionary: $0)}
        })
    }
    
    static func register(user: User) -> Resource<User> {
        let url = URL(string: "http://10.10.1.143:3000/users")!
        let dictionary = ["\(EMAIL)": user.email, "\(PASSWORD)": user.password, "\(TOKEN)": user.token]
        return Resource(url: url, method: .post(dictionary as AnyObject), parseJSON: { (json) -> User? in
            guard let dictionary = json as? JSONDictionary else { return nil }
            return User(dictionary: dictionary)
        })
    }
}
