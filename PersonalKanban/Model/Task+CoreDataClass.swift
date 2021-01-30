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

    // MARK: - computed properties

    var isArchived: Bool {
        get { self.folder == MainMenuPages.archived.int64 }
        set { self.folder = newValue ?  MainMenuPages.archived.int64 :  MainMenuPages.defaultVal.int64 }
    }

    var computedFolder: TaskFolder {
        get { TaskFolder(self.folder)  }
        set { self.folder = newValue.moValue }
    }

    var storyPointsEnum: StoryPoints {
        get { StoryPoints(self.storypoints) }
        set { self.storypoints = newValue.moValue }
    }

    var workflowStatusEnum: WorkflowPosition? { computedFolder.status }

    private func setDefaultInitialValues() {
        self.epic = TaskDefaults.epic
        self.folder = TaskDefaults.folder
        self.priority = TaskDefaults.priority
        self.stickyNote = TaskDefaults.stickyNote
        self.storypoints = TaskDefaults.storypoints.moValue
        self.title = TaskDefaults.title
    }

    private func initializeDates(dueDate due: Date? = TaskDefaults.dueDate) {
        let date = Date()
        self.dateCreated = DateConversion.format(date)
        self.dateUpdated = DateConversion.format(date)
        if let dueDate = due { self.dueDate = DateConversion.format(dueDate) }
    }

    convenience init(title: String, stickyNote: String?, storypoints: StoryPoints, folder: TaskFolder) { //, priority: TaskPriority, dueDate: Date?) {
        self.init()
        self.title = title
        self.stickyNote = stickyNote
        self.storypoints = storypoints.moValue
        self.folder = folder.moValue
//        self.priority = priority.moValue
        initializeDates(dueDate: nil)
    }

    convenience init(_ title: String, stickyNote: String?, folder: TaskFolder) {
        self.init()
        self.title = title
        self.stickyNote = stickyNote
        self.folder = folder.moValue
    }

    convenience init() {
        self.init(entity: Task.entity(), insertInto: PersistenceManager.shared.context)
        setDefaultInitialValues()
        initializeDates()
    }
}
