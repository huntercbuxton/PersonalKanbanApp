//
//  PersistenceService.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/19/20.
//

import Foundation
import CoreData

// singleton design based on tutorial by kilo loco: https://www.youtube.com/watch?v=OYRo3i9z-lM
final class PersistenceManager {

    // MARK: - properties

    static let shared = PersistenceManager()
    private let nsPersistentContainerName = "PersonalKanban"
    lazy var context: NSManagedObjectContext = persistentContainer.viewContext

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
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - methods

    func sortEpicTasks(for epic: Epic) -> [[Task]] {
        let unsorted = epic.tasksList
        var returnData: [WorkflowPosition: [Task]] = [.backlog: [],
                                                      .toDo: [],
                                                      .inProgress: [],
                                                      .finished: []
                                                    ]
        for task in unsorted {
            if let status: WorkflowPosition = task.workflowStatusEnum {
                returnData[status]?.append(task)
            }
        }
        let taskArray = [ returnData[.backlog] ?? [], returnData[.toDo] ?? [], returnData[.inProgress] ?? [], returnData[.finished] ?? [] ]
        return taskArray
    }

    func getAllTasks() -> [Task] {
        return fetch(Task.self)
    }

    func getArchivedTasks() -> [Task] {
        return getAllTasks().filter({$0.computedFolder == .archived})
    }

    func getFinishedTasks() -> [Task] {
        return getAllTasks().filter({$0.computedFolder == .finished})
    }

    func getUnassignedTasks() -> [Task] {
        return getAllTasks().filter({$0.epic == nil})
    }

    func getAllEpics() -> [Epic] {
        return fetch(Epic.self)
    }

    func delete(task: Task) {
        context.delete(task)
        save()
    }

    func delete(epic: Epic) {
        context.delete(epic)
        save()
    }

    func deleteAllData() {
        deleteAllTasks()
        deleteAllEpics()
    }

    func deleteAllTasks() {
        getAllTasks().forEach({delete(task: $0)})
    }

    func deleteAllEpics() {
        getAllEpics().forEach({delete(epic: $0)})
    }

    func deleteArchivedTasks() {
        getArchivedTasks().forEach({delete(task: $0)})
    }

    func deleteFinishedTasks() {
        getFinishedTasks().forEach({delete(task: $0)})
    }

    private func fetch<T: NSManagedObject>(_ objectType: T.Type) -> [T] {
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let fetchedObjects = try? context.fetch(fetchRequest) as? [T]
        return fetchedObjects ?? [T]()
    }

    private init() {}
}
