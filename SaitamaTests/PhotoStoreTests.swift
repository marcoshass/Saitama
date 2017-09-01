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
    
    func testInsert() {
        let store = PhotoStore()
        let photo = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: store.context) as! Photo
        photo.photoID = "My Photo ID"
        photo.photoKey = "MyKey"
        photo.title = "MyTitle"
        photo.dateTaken = NSDate()
        photo.remoteURL = nil
        
        let result = store.insert(photo: photo)
        XCTAssertNotNil(result)
    }
    
}


