//
//  MainMenuOptions.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/19/20.
//

import Foundation

public enum MainMenuOptions: Int, MenuOptionRepresentable {
    case backlog = 0
    case epics = 1
    case tasks = 2
    case finished = 3
    case more = 4

    static var allPageTitles: [String] { ["Backlog", "Epics", "Tasks", "Finished", "more"] }

    var pageTitle: String { toString() }

    // MARK: MenuOptionRepresentable conformance

    func toString() -> String {
        return MainMenuOptions.allPageTitles[self.rawValue]
    }
}
