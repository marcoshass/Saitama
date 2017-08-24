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
    let creditCard: Card?
    let email: String?
    let placeId: String?
}

extension Payment {
    init?(dictionary: JSONDictionary) {
        self.updatedAt = dictionary[UPDATEDAT] as? String
        self.createdAt = dictionary[CREATEDAT] as? String
        self.creditCard = dictionary[CREDITCARD] as? Card
        self.email = dictionary[CARDNUMBER] as? String
        self.placeId = dictionary[PLACEID] as? String
    }
}

// ----------------------------------------------------------------------------
// Api
// ----------------------------------------------------------------------------

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
    let parse: (Data) -> T?
}

extension Resource {
    
    /** Initializer with url and parseJSON:AnyObject -> T? */
    init(url: URL, method: HttpMethod<AnyObject> = .get, parseJSON: @escaping (AnyObject) -> T?) {
        self.url = url
        
        self.method = method.map{ json in
            try! JSONSerialization.data(withJSONObject: json, options: [])
        }
        
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as AnyObject
            return json.flatMap(parseJSON)
        }
    }
    
}

extension HTTPURLResponse {
    var isSuccess: Bool { return self.statusCode >= 200 && self.statusCode <= 299 }
    var isInformational: Bool { return self.statusCode >= 100 && self.statusCode <= 199 }
    var isRedirection: Bool { return self.statusCode >= 300 && self.statusCode <= 399 }
    var isClientError: Bool { return self.statusCode >= 400 && self.statusCode <= 499 }
    var isServerError: Bool{ return self.statusCode >= 500 && self.statusCode <= 599 }
}

enum ServiceError: Error {
    case badStatus(status: Int, code: Int?, message: String?)
    case other(Error)
    
    func message() -> String {
        var message = NSLocalizedString("Error", comment: "Error")
        switch self {
        case .badStatus(_, _, let msg):
            message += " \(msg ?? "")"
        case .other(let err):
            message = err.localizedDescription
        }
        return message
    }
}

extension NSMutableURLRequest {
    convenience init<A>(resource: Resource<A>) {
        self.init(url: resource.url)
        addValue("application/json", forHTTPHeaderField: "Content-Type")
        httpMethod = resource.method.method
        if case let .post(data) = resource.method {
            httpBody = data
        } else if case let .put(data) = resource.method {
            httpBody = data
        }
    }
}

final class WebService {
    
    func load<T>(_ resource: Resource<T>, completion: @escaping (T?, ServiceError?) -> ()) {
        let request = NSMutableURLRequest(resource: resource)
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if let error = error {
                completion(nil, ServiceError.other(error))
                return
            }
            
            // prepare status code and service error
            if let httpStatus = response as? HTTPURLResponse, !httpStatus.isSuccess {
                guard let data = data, let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary else {
                    completion(nil, ServiceError.badStatus(status: httpStatus.statusCode, code: nil, message: nil))
                    return
                }
                
                completion(nil, ServiceError.badStatus(status: httpStatus.statusCode, code: dict?["code"] as? Int, message: dict?["message"] as? String))
                return
            }
            
            let result = data.flatMap(resource.parse)
            completion(result, nil)
            }.resume()
    }
    
}


PlaygroundPage.current.needsIndefiniteExecution = true

// ----------------------------------------------------------------------------
// Client Api
// ----------------------------------------------------------------------------

extension User {
    
    static func login(email: String, password: String) -> Resource<User> {
        let url = URL(string: "http://www.mocky.io/v2/599e0f552500009705d303b2")! // OK
        let dictionary = ["\(EMAIL)": email, "\(PASSWORD)": password]
        return Resource(url: url, method: .post(dictionary as AnyObject), parseJSON: { (json) -> User? in
            guard let dictionary = json as? JSONDictionary else { return nil }
            return User(dictionary: dictionary)
        })
    }
    
    static func register(user: User) -> Resource<User> {
        let url = URL(string: "http://www.mocky.io/v2/599e3560250000f406d303d2")! // OK
        let dictionary = ["\(EMAIL)": user.email, "\(PASSWORD)": user.password]
        return Resource(url: url, method: .put(dictionary as AnyObject), parseJSON: { (json) -> User? in
            guard let dictionary = json as? JSONDictionary else { return nil }
            return User(dictionary: dictionary)
        })
    }
}

extension Payment {
    
    static func all(user: User) -> Resource<[Payment]> {
        let url = URL(string: "http://www.mocky.io/v2/599ed8232c00004e0051d3cb")!
        
        return Resource(url: url, parseJSON: { (json) -> [Payment]? in
            guard let dictionaries = json as? JSONDictionary else { return nil }
            guard let payments = dictionaries["payments"] as? [JSONDictionary] else { return nil }
            return payments.flatMap{Payment(dictionary: $0)}
        })
    }
    
    static func login(email: String, password: String) -> Resource<[User]> {
        let url = URL(string: "http://10.10.1.143:3000/users?email=\(email)&password=\(password)")!
        
        return Resource(url: url, parseJSON: { (json) -> [User]? in
            guard let dictionaries = json as? [JSONDictionary] else { return nil }
            return dictionaries.flatMap{User(dictionary: $0)}
        })
    }
    
}


// ----------------------------------------------------------------------------
// User call
// ----------------------------------------------------------------------------

//WebService().load(User.login(email: "marcoshass@gmail.com", password: "123456"), completion: { (data, error) in
//    if let error = error {
//        print(error.message())
//        return
//    }
//    print("")
//    print(data ?? "no data")
//})

let user = User(id: 1, email: "marcoshass@gmail.com", password: "123", token: "123")
WebService().load(Payment.all(user: user), completion: { (data, error) in
    if let error = error {
        print(error.message())
        return
    }
    
    guard let data = data else { return }
    print(data)
})

