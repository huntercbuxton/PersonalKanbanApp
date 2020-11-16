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
        get { self.folder == MainMenuPages.archived.int64 }
        set {
            self.folder = newValue ?  MainMenuPages.archived.int64 :  MainMenuPages.defaultVal.int64
        }
    }

    var notesList: [Note] {
        get { self.taskNotes?.array as! [Note] }
        set { taskNotes = NSOrderedSet(array: newValue) }
    }

    var storyPointsEnum: StoryPoints {
        get {
            guard let converted = StoryPoints(self.storypoints) else { fatalError("the value of \(self.storypoints) failed to initialize the enumerated type") }
            return converted
        }
        set {
            self.storypoints = Int64(newValue.rawValue)
        }
    }

    var workflowStatusEnum: WorkflowPosition? {
        get { return WorkflowPosition(int64: self.workflowStatus) }
        set {
            guard let num = newValue else {
                fatalError("cannot set the wprkflowStatus of a task by setting nil to the workflowStatusEnum property; only cases of the WorkflowPosition enum can be converted to rawValues. If you with to archive the task, set workflowStatus to 5 or more, or set isArchived to true ")
            }
            self.workflowStatus =  num.int64
            self.folder = num.int64
        }
    }

    private func setDefaultInitialValues() {
        self.epic = TaskDefaults.epic
        self.folder = TaskDefaults.folder
        self.primaryKey = TaskDefaults.primaryKey
        self.priority = TaskDefaults.priority
        self.stickyNote = TaskDefaults.stickyNote
        self.storypoints = Int64(TaskDefaults.storypoints.rawValue)
        self.title = TaskDefaults.title
        self.workflowStatus = Int64(TaskDefaults.workflowStatus.rawValue)
    }

    private func initializeDates(dueDate due: Date? = TaskDefaults.dueDate) {
        let date = Date()
        self.dateCreated = DateConversion.format(date)
        self.dateUpdated = DateConversion.format(date)
        if let dueDate = due { self.dueDate = DateConversion.format(dueDate) }
    }

    convenience init(title: String, stickyNote: String?, storypoints: StoryPoints, folder: Int, priority: Int, workflowStatus: WorkflowPosition, dueDate: Date?) {
        self.init()
        self.title = title
        self.stickyNote = stickyNote
        self.storypoints = Int64(storypoints.rawValue)
        self.folder = Int64(folder)
        self.priority = Int64(priority)
        self.workflowStatus = Int64(workflowStatus.rawValue)
        initializeDates(dueDate: dueDate)
    }

    convenience init(_ title: String, stickyNote: String?, folder: TaskFolder) {
        self.init()
        self.title = title
        self.stickyNote = stickyNote
        self.folder = folder.moRawVal
        self.workflowStatus = folder.moRawVal
    }

    convenience init() {
        self.init(entity: Task.entity(), insertInto: PersistenceManager.shared.context)
        setDefaultInitialValues()
        initializeDates()
    }
}
