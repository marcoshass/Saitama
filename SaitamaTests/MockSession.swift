//
//  MockSession.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 30/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import Foundation
@testable import Saitama

enum HttpStatus: Int {
    case success = 200
    case badRequest = 400
    case unprocEntity = 422
}

/**
 Utility function to return a tuple with error code and message
 */
func getError(error: ServiceError?) -> (status: Int?, code: Int?, message: String?)? {
    guard let error = error else { return nil }
    switch error {
    case .badStatus(let status, let code, let message):
        return(status, code, message)
    default:
        return nil
    }
}

class MockURLSession: URLSessionProtocol {
    let json: String
    let httpStatus: HttpStatus
    
    init(json: String, httpStatus: HttpStatus = HttpStatus.success) {
        self.json = json
        self.httpStatus = httpStatus
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        let response = HTTPURLResponse(url: request.url!, statusCode: httpStatus.rawValue, httpVersion: nil, headerFields: nil)
        completionHandler(json.data(using: String.Encoding.utf8), response, nil)
        return MockURLSessionDataTask()
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    func resume() { }
}
