//
//  TaskFolder.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/16/20.
//

import Foundation

enum TaskFolder: Int, MORawRepresentable, CaseIterable, Hashable {
    case toDo = 0, inProgress, backlog, finished, archived//, trashed

    typealias MORawVal = Int64
    var moRawVal: Int64 { Int64(self.rawValue) }
    var key: String { "folder" }

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

    static var pageDic: [MainMenuPages: TaskFolder] {
        Self.allCases.reduce(into: [MainMenuPages: TaskFolder]()) { $0[$1.page!] = $1 }
    }

    static var statusDic: [WorkflowPosition: TaskFolder] {
        Self.allCases.reduce(into: [WorkflowPosition : TaskFolder]() ) { $0[$1.status!] = $1 }
    }
}
