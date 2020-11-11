//
//  MainMenuOptions.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/19/20.
//

import Foundation

public enum MainMenuOptions: Int, MenuOptionRepresentable {
    case inProgress = 0
    case toDo = 1
    case epics = 2
    case backlog = 3
    case finished = 4
    case archived = 5

    static var allPageTitles: [String] { ["In Progress", "To Do", "Epics", "Backlog", "Finished", "Archived"] }

    var pageTitle: String { toString() }

    // MARK: MenuOptionRepresentable conformance

    func toString() -> String {
        return MainMenuOptions.allPageTitles[self.rawValue]
    }
}
