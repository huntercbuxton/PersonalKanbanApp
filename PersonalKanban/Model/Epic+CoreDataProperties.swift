//
//  Epic+CoreDataProperties.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//
//

import Foundation
import CoreData

extension Epic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Epic> {
        return NSFetchRequest<Epic>(entityName: "Epic")
    }

    @NSManaged public var title: String?
    @NSManaged public var primaryKey: UUID?
    @NSManaged public var quickNote: String?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var dateLastUpdated: Date?
    @NSManaged public var tasks: NSOrderedSet?
    @NSManaged public var epicNotes: NSOrderedSet?

}

// MARK: Generated accessors for tasks
extension Epic {

    @objc(insertObject:inTasksAtIndex:)
    @NSManaged public func insertIntoTasks(_ value: Task, at idx: Int)

    @objc(removeObjectFromTasksAtIndex:)
    @NSManaged public func removeFromTasks(at idx: Int)

    @objc(insertTasks:atIndexes:)
    @NSManaged public func insertIntoTasks(_ values: [Task], at indexes: NSIndexSet)

    @objc(removeTasksAtIndexes:)
    @NSManaged public func removeFromTasks(at indexes: NSIndexSet)

    @objc(replaceObjectInTasksAtIndex:withObject:)
    @NSManaged public func replaceTasks(at idx: Int, with value: Task)

    @objc(replaceTasksAtIndexes:withTasks:)
    @NSManaged public func replaceTasks(at indexes: NSIndexSet, with values: [Task])

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Task)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Task)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSOrderedSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSOrderedSet)

}

// MARK: Generated accessors for epicNotes
extension Epic {

    @objc(addEpicNotesObject:)
    @NSManaged public func addToEpicNotes(_ value: Note)

    @objc(removeEpicNotesObject:)
    @NSManaged public func removeFromEpicNotes(_ value: Note)

    @objc(addEpicNotes:)
    @NSManaged public func addToEpicNotes(_ values: NSSet)

    @objc(removeEpicNotes:)
    @NSManaged public func removeFromEpicNotes(_ values: NSSet)

}

extension Epic: Identifiable {

}
