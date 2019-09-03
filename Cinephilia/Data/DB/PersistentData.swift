//
//  PersistentData.swift
//  Cinephilia
//
//  Created by Amr Elghobary on 8/27/19.
//  Copyright © 2019 Amr Elghobary. All rights reserved.
//

import Foundation
import CoreData

final class PersistentData {
    
    
    private init() {}
    
    static let shared = PersistentData()
    
    
    // MARK: - Properties
    lazy var context = persistentContainer.viewContext
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "asodfnoasfd")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    // MARK: - Core Data Saving support
    func saveChanges() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
    // TODO: make hanndler to receive Result type.
    func fetch<T: NSManagedObject>(_ type: T.Type) -> [T] {
        let entityName = String(describing: type)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            if let fetchedObjects = try context.fetch(fetchRequest) as? [T] {
                return fetchedObjects
            }
        } catch {
            print(error)
        }
        
        return [T]()
    }
}
