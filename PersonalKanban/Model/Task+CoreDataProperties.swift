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

    @NSManaged public var dateCreated: Date // this should never be changed
    @NSManaged public var dateUpdated: Date // should be changed each time a change is made to a task
    @NSManaged public var dueDate: Date?
    @NSManaged public var epic: Epic?
    @NSManaged public var folder: Int64
    @NSManaged public var priority: Int64
    @NSManaged public var stickyNote: String?
    @NSManaged public var storypoints: Int64
    @NSManaged public var title: String
    @NSManaged public var workflowStatus: Int64 // make this a computed property from the 'folder' property?

}

extension Task: Identifiable {}
