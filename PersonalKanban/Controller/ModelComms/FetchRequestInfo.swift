//
//  FetchRequestInfo.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/11/20.
//

import UIKit
import CoreData

struct FetchRequestInfo<T: NSManagedObject> {
    let sortDescriptors: [NSSortDescriptor]
    let predicate: NSPredicate
    var entityName: String { String(describing: T.self) }
    var fetchRequest: NSFetchRequest<T> {
        let request = NSFetchRequest<T>(entityName: entityName)
        request.sortDescriptors = self.sortDescriptors
        request.predicate = self.predicate
        return request
    }
}

struct TaskFetchRequestDefaults {

    static var backlogTable: FetchRequestInfo<Task> = mkWorkflowFetchRequest(for: .backlog)
    static let inProgressTable: FetchRequestInfo<Task> = mkWorkflowFetchRequest(for: .inProgress)
    static let toDoTable: FetchRequestInfo<Task> = mkWorkflowFetchRequest(for: .toDo)
    static let finishedTable: FetchRequestInfo<Task> = mkWorkflowFetchRequest(for: .toDo)
    static var archivedTable: FetchRequestInfo<Task> {
        let predicateKey = "workflowStatus"
        let descriptorKey = "dateUpdated"
        let sortDescriptors = [NSSortDescriptor(key: descriptorKey, ascending: true)]
        let predicate = NSPredicate(format: "\(predicateKey) > 3 ")
        let info = FetchRequestInfo<Task>(sortDescriptors: sortDescriptors, predicate: predicate)
        return info
    }

    static func mkWorkflowFetchRequest(for section: WorkflowPosition) -> FetchRequestInfo<Task> {
        let predicateKey = "workflowStatus"
        let descriptorKey = "dateUpdated"
        let sortDescriptors = [NSSortDescriptor(key: descriptorKey, ascending: true)]
        let predicate = NSPredicate(format: "\(predicateKey) == \(section.rawValue)")
        let info = FetchRequestInfo<Task>(sortDescriptors: sortDescriptors, predicate: predicate)
        return info
    }
}
