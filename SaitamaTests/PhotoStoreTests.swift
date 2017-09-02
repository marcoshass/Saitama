//
//  PhotoStoreTests.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 01/09/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import XCTest
import CoreData
@testable import Saitama

class PhotoStoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreate_NewPhoto_ReturnNotNil() {
        let store = PhotoStore()
        let photo = store.createPhoto(dateTaken: NSDate(), photoID: "MyID", photoKey: "MyKey", remoteURL: nil, title: "MyTitle")
        XCTAssertNotNil(photo)
    }
    
    func testAll_ReturnAllPhotos() {
        let store = PhotoStore()
        let photos = store.all()
        XCTAssertNotNil(photos)
    }
    
}
