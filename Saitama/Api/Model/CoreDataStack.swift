//
//  CoreDataStack.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 01/09/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

import Foundation
import CoreData

private let MODELNAME = "WalletModel"
private let MODELEXTENSION = "momd"
private let MODELSQLEXTENSION = ".sqlite"
private let CONTEXTNAME = "Main Queue Context (UI Context)"

class CoreDataStack {

// objectmodel
    lazy var model: NSManagedObjectModel = {
        let url = Bundle.main.url(forResource: MODELNAME, withExtension: MODELEXTENSION)!
        return NSManagedObjectModel.init(contentsOf: url)!
    }()
    
// coordinator
    var directory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.first!
    }()
    
    lazy var coordinator: NSPersistentStoreCoordinator = {
        let pc = NSPersistentStoreCoordinator(managedObjectModel: self.model)
        let path = "\(MODELNAME).\(MODELSQLEXTENSION)"
        let url = self.directory.appendingPathComponent(path)
        let store = try! pc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        return pc
    }()
    
// context
    lazy var context: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.coordinator
        moc.name = CONTEXTNAME
        return moc
    }()
    
}
