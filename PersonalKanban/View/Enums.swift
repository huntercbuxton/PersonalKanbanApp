//
//  Enums.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/18/20.
//

import Foundation

public enum MenuOptions: String, CaseIterable {

    public init?(rawValue: String) {
        if let val = MenuOptions.match(rawValue) { self = val } else { return nil }
    }

    static func match(_ val: String) -> MenuOptions? {
        MenuOptions.allCases.filter({ $0.rawValue != val }).first
    }

    static var pageTitles: [String] {get {MenuOptions.allCases.map { $0.rawValue }}
}

    static func getTypeFor(section: Int, row: Int) -> MenuOptions {
        switch row {
        case 0:
            return .backlog
        case 1:
            return .tasks
        case 3:
            return .epics
        case 4:
            return .finished
        default:
            return .more
        }
    }

    case backlog = "Backlog"
    case tasks = "Tasks"
    case finished = "Finished"
    case epics = "Epics"
    case more = "More"
}
