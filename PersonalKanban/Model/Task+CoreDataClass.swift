//
//  Task+CoreDataClass.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject {

    var notesList: [Note] {
        get { return self.taskNotes?.array as! [Note] }
        set { taskNotes = NSOrderedSet(array: newValue) }
    }

}
