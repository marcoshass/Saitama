//
//  Resource.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import Foundation

// Header constants
let APPPLICATIONJSONHEADER = "application/json"
let CONTENTTYPEHEADER = "Content-Type"
let AUTHORIZATIONHEADER = "Authorization"

// Aliases
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

/**
 Custom map extension that sends the HttpBody
 */
extension HttpMethod {
    func map<B>(f: (Body) -> B) -> HttpMethod<B> {
        switch self {
        case .get: return .get
        case .post(let body): return .post(f(body))
        case .put(let body): return .put(f(body))
        }
    }
}

/**
 Resource that will be sumitted to the server
 */
struct Resource<T> {
    let url: URL
    let method: HttpMethod<Data>
    var headers: HeaderDictionary
    let parse: (Data) -> T?
}

extension Resource {
    
    /**
     Default initializer that will receive the url, httpmethod (default .get),
     HeaderDictionary with the parameters that will be sent into the header and
     the parseJSON responsible to transform the data received into the model entity
     */
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







