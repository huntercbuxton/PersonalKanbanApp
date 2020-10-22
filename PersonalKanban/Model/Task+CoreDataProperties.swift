//
//  Task+CoreDataProperties.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//
//

import Foundation
import CoreData

extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var quickNote: String?
    @NSManaged public var title: String?
    @NSManaged public var storypoints: Int64
    @NSManaged public var primaryKey: UUID?
    @NSManaged public var priority: Int64
    @NSManaged public var workflowStatus: Int64
    @NSManaged public var dueDate: Date?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var dateUpdated: Date?
    @NSManaged public var epic: Epic?
    @NSManaged public var taskNotes: NSOrderedSet?

}

// MARK: Generated accessors for taskNotes
extension Task {

    @objc(insertObject:inTaskNotesAtIndex:)
    @NSManaged public func insertIntoTaskNotes(_ value: Task, at idx: Int)

    @objc(removeObjectFromTaskNotesAtIndex:)
    @NSManaged public func removeFromTaskNotes(at idx: Int)

    @objc(insertTaskNotes:atIndexes:)
    @NSManaged public func insertIntoTaskNotes(_ values: [Task], at indexes: NSIndexSet)

    @objc(removeTaskNotesAtIndexes:)
    @NSManaged public func removeFromTaskNotes(at indexes: NSIndexSet)

    @objc(replaceObjectInTaskNotesAtIndex:withObject:)
    @NSManaged public func replaceTaskNotes(at idx: Int, with value: Task)

    @objc(replaceTaskNotesAtIndexes:withTaskNotes:)
    @NSManaged public func replaceTaskNotes(at indexes: NSIndexSet, with values: [Task])

    @objc(addTaskNotesObject:)
    @NSManaged public func addToTaskNotes(_ value: Task)

    @objc(removeTaskNotesObject:)
    @NSManaged public func removeFromTaskNotes(_ value: Task)

    @objc(addTaskNotes:)
    @NSManaged public func addToTaskNotes(_ values: NSOrderedSet)

    @objc(removeTaskNotes:)
    @NSManaged public func removeFromTaskNotes(_ values: NSOrderedSet)

}

extension Task: Identifiable {

}
