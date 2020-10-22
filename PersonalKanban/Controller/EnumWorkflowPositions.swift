//
//  EnumWorkflowPositions.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/22/20.
//

import Foundation

enum WorkflowPosition: Int, CaseIterable {
    case inProgress = 0, toDo, backlog, finished

    var displayName: String {
        let strings = ["in progress","to do","backlog","finished"]
        return strings[self.rawValue]
    }

    static var defaultStatus: WorkflowPosition { return .backlog }
}
