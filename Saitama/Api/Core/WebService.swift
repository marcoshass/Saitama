//
//  WebService.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    var isSuccess: Bool { return self.statusCode >= 200 && self.statusCode <= 299 }
    var isInformational: Bool { return self.statusCode >= 100 && self.statusCode <= 199 }
    var isRedirection: Bool { return self.statusCode >= 300 && self.statusCode <= 399 }
    var isClientError: Bool { return self.statusCode >= 400 && self.statusCode <= 499 }
    var isServerError: Bool{ return self.statusCode >= 500 && self.statusCode <= 599 }
}

enum ServiceError: Error {
    case badStatus(status: Int, jsonError: JSONDictionary?)
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
            
            // Grab the status code and the error message
            if let httpStatus = response as? HTTPURLResponse, !httpStatus.isSuccess {
                let jsonError = self.dataToJson(data: data)
                completion(nil, ServiceError.badStatus(status: httpStatus.statusCode, jsonError: jsonError))
                return
            }
            
            let result = data.flatMap(resource.parse)
            completion(result, nil)
            }.resume()
    }
    
    private func dataToJson(data: Data?) -> JSONDictionary? {
        guard let data = data, let jsonError = try? JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary else {
            return nil
        }
        return jsonError
    }
    
}

