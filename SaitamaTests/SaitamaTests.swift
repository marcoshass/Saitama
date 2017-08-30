//
//  SaitamaTests.swift
//  SaitamaTests
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import XCTest
@testable import Saitama

class SaitamaTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func XtestWebServiceLoad() {
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
            XCTAssertNotNil(data)
        })
        
    }

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
