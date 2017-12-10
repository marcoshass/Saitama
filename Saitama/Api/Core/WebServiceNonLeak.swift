//
//  WebServiceNonLeak.swift
//  Saitama
//
//  Created by marcos on 10/12/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import Foundation

public final class WebServiceNonLeak {

    public func load<T>(_ resource: Resource<T>, completion: @escaping (T?, ServiceError?) -> ()) {
        URLSession.shared.dataTask(with: resource.url) {(data, response, error) in
            if let error = error {
                completion(nil, ServiceError.other(error))
                return
            }

            // serialize the error message
            if let httpStatus = response as? HTTPURLResponse, !httpStatus.isSuccess {
                guard let err = data, let dict = try? JSONSerialization.jsonObject(with: err, options: []) as? JSONDictionary
                else {
                    completion(nil, ServiceError.badStatus(status: httpStatus.statusCode, code: nil, message: nil))
                    return
                }
            
                completion(nil, ServiceError.badStatus(status: httpStatus.statusCode, code: dict?["code"] as? Int, message: dict?["message"] as? String))
                return
            }
            
            // http ok
            let result = data.flatMap(resource.parse)
            completion(result, nil)
        }.resume()
    }
    
}
