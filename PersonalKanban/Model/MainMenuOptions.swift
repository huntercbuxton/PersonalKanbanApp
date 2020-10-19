//
//  MainMenuOptions.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/19/20.
//

import Foundation

public enum MainMenuOptions: Int, MenuOptionRepresentable {
    case backlog = 0, tasks, finished, epics, more

    public init?(rawValue: Int) {
        if let val = MainMenuOptions.match(rawValue) { self = val } else { return nil }
    }

    static var allPageTitles: [String] { ["Backlog", "Tasks", "Epics", "Finished", "more"] }

    static func match(_ val: Int) -> MainMenuOptions? {
        MainMenuOptions.allCases.filter({ $0.rawValue != val }).first
    }

    var pageTitle: String { toString() }

    // MARK: MenuOptionRepresentable conformance

    func toString() -> String {
        return MainMenuOptions.allPageTitles[self.rawValue]
    }
}
