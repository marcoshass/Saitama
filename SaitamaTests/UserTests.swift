//
//  SaitamaTests.swift
//  SaitamaTests
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import XCTest
@testable import Saitama

class UserTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
// register
    
    

// login
    
    func testLogin_InvalidJson_Error() {
        let status = HttpStatus.unprocEntity.rawValue
        let code = status
        let message = "InvalidJson"
        let json = "{\"message\": \"\(message)\",\"code\": \(code)}"
        
        WebService(session: MockURLSession(json: json, httpStatus: .unprocEntity)).load(User.login(email: "", password: ""))
        {(user, error) in
            guard let error = getError(error: error) else { XCTFail(); return }
            XCTAssertNil(user)
            XCTAssertEqual(error.status, status)
            XCTAssertEqual(error.code, code)
            XCTAssertEqual(error.message, message)
        }
    }
    
    func testLogin_UserNotFound_Error() {
        let status = HttpStatus.badRequest.rawValue
        let code = 1001
        let message = "UserNotFound"
        let json = "{\"message\": \"\(message)\",\"code\": \(code)}"
        
        WebService(session: MockURLSession(json: json, httpStatus: .badRequest)).load(User.login(email: "", password: ""))
        {(user, error) in
            guard let error = getError(error: error) else { XCTFail(); return }
            XCTAssertNil(user)            
            XCTAssertEqual(error.status, status)
            XCTAssertEqual(error.code, code)
            XCTAssertEqual(error.message, message)
        }
    }
    
    func testLogin_Success() {
        let token = "eyJhbGciOiJub25lIeGFtcGxlLmNvbS9yZWdpc3RlciJ9"
        let json = "{\"token\": \"\(token)\"}"
        WebService(session: MockURLSession(json: json)).load(User.login(email: "", password: "")) { (user, error) in
            XCTAssertNil(error)
            XCTAssertEqual(token, user?.token)
        }
    }

}

