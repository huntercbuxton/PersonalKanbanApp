//
//  MainMenuOptions.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/19/20.
//

import Foundation

public enum MainMenuPages: Int, CaseIterable {
    case toDo = 0, epics, inProgress, backlog, finished, archived, more

    static let defaultVal: MainMenuPages = .toDo
    var int64: Int64 { Int64(self.rawValue) }
    static var titlesDic: [ MainMenuPages: String] = [ .toDo: "to do", .epics: "epics", .inProgress: "in progress", .backlog: "backlog", .finished: "finished", .archived: "archived", .more: "more" ]
    var title: String { MainMenuPages.titlesDic[self]! }

    init?(int64 rawValue: Int64) { self.init(rawValue: Int(rawValue)) }
}
