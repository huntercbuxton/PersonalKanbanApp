//
//  TaskDefaults.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/16/20.
//

import Foundation

struct TaskDefaults {
    static let dueDate: Date? = nil
    static let epic: Epic? = nil
    static let folder: Int64 = 0
    static let primaryKey: UUID? = nil
    static let priority: Int64 = 0
    static let stickyNote: String? = nil
    static let storypoints: StoryPoints = .defaultVal
    static let title: String = "default title text"
    static let workflowStatus: WorkflowPosition = .toDo
}