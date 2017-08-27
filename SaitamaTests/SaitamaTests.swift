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
    
    let url = URL(string: "http://masilotti.com")!
    var webservice: WebService!
    let session = MockURLSession()

    override func setUp() {
        super.setUp()
        self.webservice = WebService(session: session)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testServiceKeepTrackURL() {
        let resource = Resource(url: url, parseJSON: { (_) -> NSObject? in return nil })

        webservice.load(resource) { (_, _) in }
        XCTAssert(session.lastRequest?.url == url)
    }
    
    func testServiceResumeCalled() {
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        
        let resource = Resource(url: url, parseJSON: { (_) -> NSObject? in return nil })
        webservice.load(resource) { (_, _) in }
        
        XCTAssertTrue(dataTask.resumeCalled)
    }
    
}

/**
 Mock implementation for URLSession that tracks the last request
 */
class MockURLSession: URLSessionProtocol {
    var lastRequest: URLRequest?
    var nextDataTask = MockURLSessionDataTask()
    
    var nextData: Data?
    var nextError: Error?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastRequest = request
        completionHandler(nextData, nil, nextError)
        return nextDataTask
    }
}

/**
 Mock implementation for URLSessionDataTask that tracks resume()
 */
class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    var resumeCalled = false
    
    func resume() {
        resumeCalled = true
    }
}
