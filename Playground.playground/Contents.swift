//: Playground - noun: a place where people can play

import Foundation
import PlaygroundSupport
//import SaitamaPlayground

typealias JSONDictionary = [String: AnyObject]

// ----------------------------------------------------------------------------
// Place
// ----------------------------------------------------------------------------

let CREATEDAT: String = "createdAt"
let ID: String = "id"
let LOCATION: String = "location"
let NAME: String = "name"
let UPDATEDAT: String = "updatedAt"

struct Place {
    let createdAt: String?
    let id: String?
    let location: String?
    let name: String?
    let updatedAt: String?
}

extension Place {
    init(dictionary: JSONDictionary) {
        self.createdAt = dictionary[CREATEDAT] as? String
        self.id = dictionary[ID] as? String
        self.location = dictionary[LOCATION] as? String
        self.name = dictionary[NAME] as? String
        self.updatedAt = dictionary[UPDATEDAT] as? String
    }
}

// ----------------------------------------------------------------------------
// API
// ----------------------------------------------------------------------------

struct Resource<T> {
    let url: URL
    let parse: (Data) -> T?
}

extension Resource {
    init(url: URL, parseJSON: @escaping (AnyObject)->(T?)) {
        self.url = url
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as AnyObject
            return json.flatMap(parseJSON)
        }
    }
}

final class WebService {
    
    func load<T>(resource: Resource<T>, completion: @escaping (T?, Error?) ->()) {
        URLSession.shared.dataTask(with: resource.url) {(data, _, error) in
            guard let data = data else { completion(nil, error); return }
            completion(resource.parse(data), error)
        }.resume()
    }
    
}

// ----------------------------------------------------------------------------
// Client
// ----------------------------------------------------------------------------

PlaygroundPage.current.needsIndefiniteExecution = true

let url = URL(string: "http://www.mocky.io/v2/599f29ea2c0000820151d480")!
let placesResource = Resource<[Place]>(url: url, parseJSON: {(json) -> [Place]? in
    guard let places = json["places"] as? [JSONDictionary] else { return nil }
    return places.flatMap{Place(dictionary: $0)}
})

WebService().load(resource: placesResource, completion: {(places, error) in
    print(places ?? "noplaces")
})


