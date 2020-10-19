//
//  Task+CoreDataProperties.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/19/20.
//
//

import Foundation
import CoreData

extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var title: String
    @NSManaged public var notes: String?

}

extension Task: Identifiable {

}
