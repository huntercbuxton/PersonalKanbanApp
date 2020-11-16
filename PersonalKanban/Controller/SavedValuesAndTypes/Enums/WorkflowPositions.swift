//
//  EnumWorkflowPositions.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/22/20.
//

import Foundation

enum WorkflowPosition: Int, CaseIterable, MORawRepresentable {
    case inProgress = 0, toDo, backlog, finished

    typealias MORawVal = Int64
    var defaultVal: MORawVal { WorkflowPosition.backlog.int64 }
    var moRawVal: MORawVal { int64 }
    var key: String { "workflowStatus" }

    var toString: String { String(describing: self) }
    var int64: Int64 { Int64(rawValue) }
    var menuPage: MainMenuPages? {
        switch self {
        case .inProgress: return .inProgress
        case .toDo: return .toDo
        case .backlog: return .backlog
        case .finished: return .finished
        }
    }

    static var defaultVal: WorkflowPosition { return .backlog }

    init?(int64: Int64) { self.init(rawValue: Int(int64)) }

}
