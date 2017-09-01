//
//  Photo+CoreDataClass.swift
//  
//
//  Created by Marcos Hass Wakamatsu on 01/09/17.
//
//  This file was automatically generated and should not be edited.
//

import UIKit
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {

    var image: UIImage?

    override func awakeFromInsert() {
        super.awakeFromInsert()
        title = ""
        photoID = ""
        remoteURL = URL()
    }
    
}
