//: Playground - noun: a place where people can play

import Foundation
import PlaygroundSupport
//import SaitamaPlayground

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
    init(dictionary: NSDictionary) {
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

typealias JSONDictionary = [String: AnyObject]

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

struct Resource {
    let url: URL
    let method: HttpMethod = .get
    let parse: (Data)->Any?
}

extension Resource {
    init(url: URL, parseJSON: @escaping (Any)->Any?) {
        self.url = url
        self.parse = {(data)->Any? in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            return json.flatMap{parseJSON($0)}
        }
    }
}

final class WebService {
    func load(resource: Resource, completion: @escaping (Any?, Error?)->()) {
        URLSession.shared.dataTask(with: resource.url) {(data, response, error) in
            let result = data.flatMap {resource.parse($0)}
            completion(result, error)
        }.resume()
    }
}

PlaygroundPage.current.needsIndefiniteExecution = true

let url = URL(string: "http://www.mocky.io/v2/599f29ea2c0000820151d480")!
let placesResource = Resource(url: url, parseJSON:{(json) -> Any? in
    let json1 = (json as! JSONDictionary)["places"]
    return json1.flatMap{Place(dictionary: $0)}
})


WebService().load(resource: placesResource, completion: {(places, error) in
    print(places ?? "nodata")
})







