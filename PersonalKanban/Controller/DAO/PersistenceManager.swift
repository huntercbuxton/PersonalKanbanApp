//
//  PersistenceService.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/19/20.
//

import Foundation
import CoreData

// based on tutorial by kilo loco:
// https://www.youtube.com/watch?v=OYRo3i9z-lM

final class PersistenceManager {

    // MARK: API

    static let shared = PersistenceManager()

    lazy var context: NSManagedObjectContext = persistentContainer.viewContext

    func getAllTasks() -> [Task] {
        return self.fetch(Task.self)
    }

    // MARK: private methods/properties

    private func fetch<T: NSManagedObject>(_ objectType: T.Type) -> [T] {
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let fetchedObjects = try? context.fetch(fetchRequest) as? [T]
            return fetchedObjects ?? [T]()
        } catch {
            print(error)
            fatalError("PersistenceManager caught an error while performing a fetch request in \(#function)")
        }
    }

    private init() {}

    private let nsPersistentContainerName = "PersonalKanban"

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: nsPersistentContainerName)
        container.loadPersistentStores(completionHandler: { (_, error) in
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

    func save() {
        if context.hasChanges {
            do {
                try context.save()
                print("the PersistenceManager executed context.save() successfully)")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
