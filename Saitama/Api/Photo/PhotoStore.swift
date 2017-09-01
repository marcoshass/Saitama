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
    
    func insert(photo: Photo) -> Photo? {
        var newPhoto: Photo?
        context.performAndWait {
            if let entity = NSEntityDescription.insertNewObject(forEntityName: PhotoEntity, into: self.context) as? Photo {
                entity.photoID = photo.photoID
                entity.photoKey = photo.photoKey
                entity.title = photo.title
                entity.dateTaken = photo.dateTaken
                entity.remoteURL = nil
                newPhoto = entity
            }
        }
        return newPhoto
    }
    
}
