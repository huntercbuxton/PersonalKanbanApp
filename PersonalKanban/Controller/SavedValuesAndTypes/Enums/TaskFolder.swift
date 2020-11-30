//
//  TaskFolder.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/16/20.
//

import Foundation

enum TaskFolder: Int, MORawRepresentable, CaseIterable, Hashable {
    case toDo = 0, inProgress, backlog, finished, archived//, trashed

    typealias MOValue = Int64

    var moPropertyKey: String { "folder" }

    static var caseDefault: MOValue { Self.toDo.moValue }

    var page: MainMenuPages? {
        switch self {
        case .toDo: return .toDo
        case .inProgress: return .inProgress
        case .backlog: return .backlog
        case .finished: return .finished
        case .archived: return .archived
        }
    }

    var status: WorkflowPosition? {
        switch self {
        case .toDo: return .toDo
        case .inProgress: return .inProgress
        case .backlog: return .backlog
        case .finished: return .finished
        default: return nil
        }
    }

    static var workflowPages: [TaskFolder] { Self.allCases.filter({ $0.status != nil }) }

    static var pageDic: [MainMenuPages: TaskFolder] {
        Self.allCases.reduce(into: [MainMenuPages: TaskFolder]()) { $0[$1.page!] = $1 }
    }

    static var statusDic: [WorkflowPosition: TaskFolder] {
        Self.workflowPages.reduce(into: [WorkflowPosition: TaskFolder]() ) { $0[$1.status!] = $1 }
    }
}
