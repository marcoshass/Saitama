//
//  Resource.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import Foundation

let APPPLICATIONJSONHEADER = "application/json"
let CONTENTTYPEHEADER = "Content-Type"
let AUTHORIZATIONHEADER = "Authorization"

typealias JSONDictionary = [String: AnyObject]
typealias HeaderDictionary = [String: String]
typealias HttpParameters = [String: String]

enum HttpMethod<Body> {
    case get
    case post(Body)
    case put(Body)
}

extension HttpMethod {
    var method: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        }
    }
}

extension HttpMethod {
    func map<B>(f: (Body) -> B) -> HttpMethod<B> {
        switch self {
        case .get: return .get
        case .post(let body): return .post(f(body))
        case .put(let body): return .put(f(body))
        }
    }
}

struct Resource<T> {
    let url: URL
    let method: HttpMethod<Data>
    var headers: HeaderDictionary
    let parse: (Data) -> T?
}

extension Resource {
    
    /** Initializer with url and parseJSON:AnyObject -> T? */
    init(url: URL, method: HttpMethod<AnyObject> = .get, headers: HeaderDictionary? = nil, parseJSON: @escaping (AnyObject) -> T?) {
        self.url = url

        self.method = method.map{ json in
            try! JSONSerialization.data(withJSONObject: json, options: [])
        }
        
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as AnyObject
            return json.flatMap(parseJSON)
        }

        var result: HeaderDictionary = [APPPLICATIONJSONHEADER: CONTENTTYPEHEADER]
        if let headers = headers {
            _ = headers.map { (k,v) in result[k] = v }
        }
        self.headers = result
        print("headers=\(self.headers)")
    }
    
}







