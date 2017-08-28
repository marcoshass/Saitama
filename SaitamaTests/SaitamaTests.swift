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
    
    func testWebServiceLoad() {
        let url = URL(string: "http://www.mocky.io/v2/599f29ea2c0000820151d480")!
        let resource = Resource(url: url) { (_) -> NSObject? in return nil }
        WebService().load(resource) { (data, error) in
            
        }
    }

}

class MockURLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        print("datatask=called")
        return MockURLSessionDataTask()
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    func resume() {
        print("resume=called")
    }
}
