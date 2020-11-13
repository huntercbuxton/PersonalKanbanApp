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

    var isArchived: Bool {
        get {
            return self.workflowStatus > 3
        }
        set {
            if newValue {
                self.workflowStatus = Int64(5)
            } else if isArchived {
                self.workflowStatus = Int64(0)
            }
        }
    }

    var notesList: [Note] {
        get { return self.taskNotes?.array as! [Note] }
        set { taskNotes = NSOrderedSet(array: newValue) }
    }

    var storyPointsEnum: StoryPoints {
        get {
            guard let converted = StoryPoints(from: self.storypoints) else { fatalError("the value of \(self.storypoints) failed to initialize the enumerated type") }
            return converted
        }
        set {
            self.storypoints = Int64(newValue.rawValue)
        }
    }

    var workflowStatusEnum: WorkflowPosition? {
        get {
            return WorkflowPosition(rawValue: Int(self.workflowStatus))
        }
        set {
            guard let num = newValue else {
                fatalError("cannot set the wprkflowStatus of a task by setting nil to the workflowStatusEnum property; only cases of the WorkflowPosition enum can be converted to rawValues. If you with to archive the task, set workflowStatus to 5 or more, or set isArchived to true ")
            }
            self.workflowStatus =  Int64(num.rawValue)
        }
    }
}
