//
//  WebService.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import Foundation

/**
 Utility extension to detected when something go wrong in the
 response, avoiding to put conditionals inside of the WebService
 class
 */
extension HTTPURLResponse {
    var isSuccess: Bool { return self.statusCode >= 200 && self.statusCode <= 299 }
    var isInformational: Bool { return self.statusCode >= 100 && self.statusCode <= 199 }
    var isRedirection: Bool { return self.statusCode >= 300 && self.statusCode <= 399 }
    var isClientError: Bool { return self.statusCode >= 400 && self.statusCode <= 499 }
    var isServerError: Bool{ return self.statusCode >= 500 && self.statusCode <= 599 }
}

/**
 Custom error implementation that is sent as a result of
 the server requests. When the error is not identified it's
 wrapped into one of the .case
 */
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

/**
 NSMutableURLRequest extension that builds up that
 parameters that were embedded into the Resource
 like the method, body and authentication header
 */
extension NSMutableURLRequest {
    convenience init<A>(resource: Resource<A>) {
        self.init(url: resource.url)
        _ = resource.headers.map { (k,v) in addValue(k, forHTTPHeaderField: v) }
        httpMethod = resource.method.method
        if case let .post(data) = resource.method {
            httpBody = data
        } else if case let .put(data) = resource.method {
            httpBody = data
        }
    }
}

/**
 Responsible for the interaction with the rest api, receives a 
 Resource object that carries the url, methods, headers and the 
 json parse function. This class was created this way to avoid
 a singleton misuse in the application
 */
final class WebService: NSObject, URLSessionDelegate {
    var session: URLSessionProtocol?
    
    /**
     Initializer that receives the URLSession protocol 
     added to provide support to unit testing
     */
    init(session: URLSessionProtocol? = nil) {
        super.init()
        guard let session = session else { self.session = URLSession(configuration: .default, delegate: self, delegateQueue: nil); return }
        self.session = session
    }
    
    /**
     Loads the data through the network. http and self signed 
     certificates were allowed just for testing purposes at
     this method and at Info.plist
     */
    func load<T>(_ resource: Resource<T>, completion: @escaping (T?, ServiceError?) -> ()) {
        let request = NSMutableURLRequest(resource: resource)
        guard let session = session else { return }
        session.dataTask(with: request as URLRequest) { (data, response, error) in
            // Wraps unknown error to conform to ServiceError enum
            // so the client will just receive ServiceError items
            if let error = error {
                completion(nil, ServiceError.other(error))
                return
            }
            
            // Check the status code that's a standard of the Saitama
            // api and encapsulates the responde with the code and the
            // description providede by the api 
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
    
    /** Allow self signed certificates just for testing purposes */
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
    

}

// ----------------------------------------------------------------------------
// Test support for URLSession
// ----------------------------------------------------------------------------

typealias DataTaskResult = (Data?, URLResponse?, Error?) -> ()

protocol URLSessionProtocol {
    func dataTask(with: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        return (dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
}

// ----------------------------------------------------------------------------
// Test support for URLSessionDataTask
// ----------------------------------------------------------------------------

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {
    
}
