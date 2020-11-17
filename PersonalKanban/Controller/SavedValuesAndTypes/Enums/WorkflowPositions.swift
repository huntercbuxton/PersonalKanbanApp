//
//  EnumWorkflowPositions.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/22/20.
//

import Foundation

public enum WorkflowPosition: Int, CaseIterable, MORawRepresentable {
    case inProgress = 0, toDo, backlog, finished

    typealias MOValue = Int64

    var moPropertyKey: String { "workflowStatus" }

    static var caseDefault: MOValue { Self.toDo.moValue }

    var toString: String { String(describing: self) }

    var menuPage: MainMenuPages? {
        switch self {
        case .inProgress: return .inProgress
        case .toDo: return .toDo
        case .backlog: return .backlog
        case .finished: return .finished
        }
    }

    var folder: TaskFolder { TaskFolder.statusDic[self]! }
}
