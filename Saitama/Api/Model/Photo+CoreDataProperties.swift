//
//  Photo+CoreDataProperties.swift
//  
//
//  Created by Marcos Hass Wakamatsu on 01/09/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var photoID: String
    @NSManaged public var photoKey: String
    @NSManaged public var title: String
    @NSManaged public var dateTaken: NSDate
    @NSManaged public var remoteURL: URL

}
