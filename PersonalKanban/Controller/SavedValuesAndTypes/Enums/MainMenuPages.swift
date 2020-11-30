//
//  MainMenuOptions.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/19/20.
//

import Foundation

public enum MainMenuPages: Int, CaseIterable {
    case toDo = 0, epics, inProgress, backlog, finished, archived

    var defaultVal: MainMenuPages { .backlog }
    var int64: Int64 { Int64(self.rawValue) }
    var toString: String { String(describing: self) }

    static var allPageTitles: [String] { Self.allCases.map({$0.toString})}
    static let defaultVal: MainMenuPages = .toDo

    init?(int64 rawValue: Int64) { self.init(rawValue: Int(rawValue)) }
}
