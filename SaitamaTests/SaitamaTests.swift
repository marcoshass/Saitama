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
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetToWebSite() {
        let url = URL(string: "http://masilotti.com")!
        let exp = expectation(description: "Wait for \(url) to load")
        var data: Data?
        
        URLSession.shared.dataTask(with: url) { (netData, _, _) in
            data = netData
            exp.fulfill()

        }.resume()
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(data)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
