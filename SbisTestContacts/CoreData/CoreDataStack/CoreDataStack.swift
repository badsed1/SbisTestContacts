//
//  CoreDataStack.swift
//  SbisTestContacts
//
//  Created by Евгений Стадник on 03.06.2018.
//  Copyright © 2018 Евгений Стадник. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    var context: NSManagedObjectContext
    var persistantStoreCoordinator: NSPersistentStoreCoordinator
    var managedModel: NSManagedObjectModel
    var persistantStore: NSPersistentStore?
    
    init() {
        let bundle = Bundle.main
        let modelURL = bundle.url(forResource: "SbisTestContacts", withExtension: "momd")
        
        managedModel = NSManagedObjectModel(contentsOf: modelURL!)!
        
        persistantStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedModel)
        
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistantStoreCoordinator
        
        let documentsURL = CoreDataStack.applicationDocumentsDirrectory()
        let storeURL = documentsURL.appendingPathComponent("SbisTestContacts")
        
        let options = [NSMigratePersistentStoresAutomaticallyOption: true]
        do {
            persistantStore = try persistantStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
        } catch let error as NSError {
            print(error.userInfo)
        }
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch let error as NSError {
            print(error.userInfo)
        }
    }
    
    static func applicationDocumentsDirrectory() -> NSURL {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask) as Array<NSURL>
        return urls.first!
    }
}
