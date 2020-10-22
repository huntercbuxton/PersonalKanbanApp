//
//  Note+CoreDataProperties.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//
//

import Foundation
import CoreData

extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var textContent: String?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var highlight: Int64
    @NSManaged public var taskNotes: Task?
    @NSManaged public var epicNotes: Epic?

}

extension Note: Identifiable {

}
