//
//  SaitamaUITests.swift
//  SaitamaUITests
//
//  Created by Marcos Hass Wakamatsu on 23/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import XCTest

class SaitamaUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        app.launchArguments += ["UI-TESTING"]
        app.launchEnvironment["http://www.mocky.io/v2/599f29ea2c0000820151d480"] =
            "{                                                          " +
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
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
    }
    
}





