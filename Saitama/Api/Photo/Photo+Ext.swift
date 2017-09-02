//
//  PhotoStore.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 01/09/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import Foundation
import CoreData

private let PhotoEntity = "Photo"

class PhotoStore {
    
    let context = CoreDataStack().context
    
    func all() -> [Photo]? {
        return try? context.fetch(NSFetchRequest<Photo>(entityName: PhotoEntity)) as [Photo]
    }
    
    func createPhoto(dateTaken: NSDate?, photoID: String?, photoKey: String?, remoteURL: NSObject?, title: String?) -> Photo? {
        guard let photo = NSEntityDescription.insertNewObject(forEntityName: PhotoEntity, into: self.context) as? Photo else { return nil }
        photo.dateTaken = dateTaken
        photo.photoID = photoID
        photo.photoKey = photoKey
        photo.remoteURL = remoteURL
        photo.title = title
        return photo
    }
    
}
