//: Playground - noun: a place where people can play

import Foundation
import PlaygroundSupport

typealias JSONDictionary = [String: AnyObject]

// ----------------------------------------------------------------------------
// User
// ----------------------------------------------------------------------------

struct User {
    let id: Int?
    let name: String?
    var email: String?
    let password: String?
    let token: String?
}

extension User {
    init?(dictionary: JSONDictionary) {
        self.id = dictionary["id"] as? Int
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.password = dictionary["password"] as? String
        self.token = dictionary["token"] as? String
    }
}

// ----------------------------------------------------------------------------
// Api
// ----------------------------------------------------------------------------

enum HttpMethod<Body> {
    case get
    case post(Body)
}

extension HttpMethod {
    var method: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
}

extension HttpMethod {
    func map<B>(f: (Body) -> B) -> HttpMethod<B> {
        switch self {
        case .get: return .get
        case .post(let body): return .post(f(body))
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
    var isClientError: Bool{ return self.statusCode >= 400 && self.statusCode <= 499 }
    var isServerError: Bool{ return self.statusCode >= 500 && self.statusCode <= 599 }
}

enum ServiceError: Error {
    case badStatus(status: Int)
    case other(Error)
}

extension NSMutableURLRequest {
    convenience init<A>(resource: Resource<A>) {
        self.init(url: resource.url)
        addValue("application/json", forHTTPHeaderField: "Content-Type")
        httpMethod = resource.method.method
        if case let .post(data) = resource.method {
            httpBody = data
        }
    }
}

final class WebService {
    
    func load<T>(_ resource: Resource<T>, completion: @escaping (T?, Error?) -> ()) {
        let request = NSMutableURLRequest(resource: resource)
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if let error = error {
                completion(nil, ServiceError.other(error))
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, !httpStatus.isSuccess {
                completion(nil, ServiceError.badStatus(status: httpStatus.statusCode))
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
    static func login(email: String, password: String) -> Resource<[User]> {
        let url = URL(string: "http://localhost:3000/users?email=\(email)&password=\(password)")!
        return Resource(url: url, parseJSON: { (json) -> [User]? in
            guard let dictionaries = json as? [JSONDictionary] else { return nil }
            return dictionaries.flatMap{User(dictionary: $0)}
        })
    }
    
    static func register(user: User) -> Resource<User> {
        let url = URL(string: "https://reqres.in/api/register")!
        let dictionary = ["name": user.name, "email": user.email, "password": user.password]
        return Resource(url: url, method: .post(dictionary as AnyObject), parseJSON: { (json) -> User? in
            guard let dictionary = json as? JSONDictionary else { return nil }
            return User(dictionary: dictionary)
        })
    }
}

// ----------------------------------------------------------------------------
// User call
// ----------------------------------------------------------------------------



WebService().load(User.login(email: "marcoshass@gmail.com", password: "123456"), completion: { (data, error) in
    //    print(data ?? "no data found")
})


var str = UUID().uuidString
print(String(str.characters.prefix(3)))
