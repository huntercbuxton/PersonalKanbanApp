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

    func sort() -> [Task] {
        let entityName = String(describing: Task.self)
        let request = NSFetchRequest<Task>(entityName: entityName)
        let predicateKey = "workflowStatus"
        let descriptorKey = "dateUpdated"
        let sortDescriptor = NSSortDescriptor(key: descriptorKey, ascending: true)
        request.sortDescriptors = [sortDescriptor]
        request.predicate = NSPredicate(format: "\(predicateKey) == 0")
        do {
            let objects = try context.fetch(request) as [Task]
            return objects ?? [Task]()
        } catch {
            fatalError("failed to perform the fetch request in the method \(#function)")
        }
    }

    func sortEpicTasks(for epic: Epic) -> [[Task]] {
        let unsorted = epic.tasksList
        var returnData: [WorkflowPosition:[Task]] = [.backlog:[],
                                                      .toDo:[],
                                                      .inProgress:[],
                                                      .finished:[]
                                                    ]
        for task in unsorted {
            if task.workflowStatusEnum != .defaultStatus {
                returnData[task.workflowStatusEnum]?.append(task)
            }
        }
        let taskArray = [ returnData[.backlog] ?? [], returnData[.toDo] ?? [], returnData[.inProgress] ?? [], returnData[.finished] ?? [] ]
        return taskArray
    }

    func sort(match workflowPosition: WorkflowPosition) -> [Task] {
        let entityName = String(describing: Task.self)
        let request = NSFetchRequest<Task>(entityName: entityName)
        let predicateKey = "workflowStatus"
        let descriptorKey = "dateUpdated"
        let sortDescriptor = NSSortDescriptor(key: descriptorKey, ascending: true)
        request.sortDescriptors = [sortDescriptor]
        request.predicate = NSPredicate(format: "\(predicateKey) == \(workflowPosition.rawValue)")
        do {
            let objects = try context.fetch(request) as [Task]
            return objects ?? [Task]()
        } catch {
            fatalError("failed to perform the fetch request in the method \(#function)")
        }
    }

    func getAllTasks() -> [Task] {
        let tasks = self.fetch(Task.self)
        print("these are the current tasks:")
//        tasks.forEach({print("task title: \($0.title) with status: \($0.workflowStatus) ")})
        return tasks
    }

    func getUnassignedTasks() -> [Task] {
        var tasks = self.getAllTasks()
        return tasks.filter({$0.epic == nil})
    }

    func getAllEpics() -> [Epic] {
        let epics = self.fetch(Epic.self)
        print("these are the current epics:")
//        epics.forEach({print($0.title, "tasks.count:", $0.tasks?.count)})
        return epics
    }

    func delete(task: Task) {
        context.delete(task)
        save()
    }

    func delete(epic: Epic) {
        context.delete(epic)
        save()
    }

    func deleteAllTasks() {
        print("now calling \(#function)")
        let tasks = getAllTasks()
        tasks.forEach({self.delete(task: $0)})
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
