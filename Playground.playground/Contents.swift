//: Playground - noun: a place where people can play

import Foundation
import PlaygroundSupport
import SaitamaPlayground

// ----------------------------------------------------------------------------
// Utility
// ----------------------------------------------------------------------------

/**
 Static DateFormatters to be used throughout the
 application and save resources for data parsing
 */
struct Format {
    
    static let utc: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
    
    static let utcShort: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
}

// ----------------------------------------------------------------------------
// Location
// ----------------------------------------------------------------------------

private let LAT = "lat"
private let LNG = "lng"

struct Location {
    let lat: Double?
    let lng: Double?
}

extension Location {
    init?(dictionary: JSONDictionary) {
        self.lat = dictionary[LAT]?.doubleValue
        self.lng = dictionary[LNG]?.doubleValue
    }
}

// ----------------------------------------------------------------------------
// Place
// ----------------------------------------------------------------------------

private let PLACES = "places"
private let UPDATEDAT = "updatedAt"
private let CREATEDAT = "createdAt"
private let ID = "id"
private let NAME = "name"
private let LOCATION = "location"

struct Place {
    var updatedAt: Date?
    var createdAt: Date?
    let id: String?
    let name: String?
    var location: Location?
}

extension Place {
    init?(dictionary: JSONDictionary) {
        if let updatedAt = dictionary[UPDATEDAT] as? String { self.updatedAt = Format.utc.date(from: updatedAt) }
        if let createdAt = dictionary[CREATEDAT] as? String { self.createdAt = Format.utc.date(from: createdAt) }
        self.id = dictionary[ID] as? String
        self.name = dictionary[NAME] as? String
        if let dict = dictionary[LOCATION] as? JSONDictionary { self.location = Location(dictionary: dict) }
    }
}

extension Place {
    
    /** Retrieves all places where bikes can be rent, auth token not needed */
    static func all() -> Resource<[Place]> {
        let url = URL(string: "http://www.mocky.io/v2/599f29ea2c0000820151d480")!
        return Resource(url: url, parseJSON: { (json) -> [Place]? in
            guard let dictionaries = json as? JSONDictionary else { return nil }
            guard let places = dictionaries[PLACES] as? [JSONDictionary] else { return nil }
            return places.flatMap{Place(dictionary: $0)}
        })
    }
    
}

PlaygroundPage.current.needsIndefiniteExecution = true

// ----------------------------------------------------------------------------
// Api
// ----------------------------------------------------------------------------

func testWebServiceLoad() {
    let json = "{                                                   " +
        "\"places\": [                                              " +
        "  {                                                        " +
        "    \"updatedAt\": \"2016-12-23T19:31:10.340Z\",           " +
        "    \"createdAt\": \"2016-12-23T19:31:10.340Z\",           " +
        "    \"id\": \"45c0b5209973fcec652817e16e20f1d0b4ecb602\",  " +
        "    \"name\": \"Tokyo\",                                   " +
        "    \"location\": {                                        " +
        "      \"lat\": \"35.7090259\",                             " +
        "      \"lng\": \"139.7319925\"                             " +
        "    }                                                      " +
        "  },                                                       " +
        "  {                                                        " +
        "    \"updatedAt\": \"2016-12-23T19:31:10.354Z\",           " +
        "    \"createdAt\": \"2016-12-23T19:31:10.354Z\",           " +
        "    \"id\": \"83489d15abb8214530f554d5731b902bf4de9d08\",  " +
        "    \"name\": \"Hotel Mid In Akabane Ekimae\",             " +
        "    \"location\": {                                        " +
        "      \"lat\": \"35.776904\",                              " +
        "      \"lng\": \"139.7222837\"                             " +
        "  }                                                        " +
        "}]                                                         " +
    "}"
    
    WebService(session: MockURLSession(json: json)).load(Place.all(), completion: { (data, error) in
        if let error = error {
            print("error=\(error)")
            return
        }
        
        guard let data = data else {
            print("nodata")
            return
        }
        
        print("data=\(data)")
    })
    
}

class MockURLSession: URLSessionProtocol {
    let json: String
    
    init(json: String) {
        self.json = json
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        completionHandler(json.data(using: String.Encoding.utf8), response, nil)
        return MockURLSessionDataTask()
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    func resume() { }
}

// ----------------------------------------------------------------------------
// Client
// ----------------------------------------------------------------------------

testWebServiceLoad()
