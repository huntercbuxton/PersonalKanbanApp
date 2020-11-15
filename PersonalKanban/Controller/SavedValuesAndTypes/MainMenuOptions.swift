//
//  MainMenuOptions.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/19/20.
//

import Foundation

public enum MainMenuOptions: Int, MenuOptionRepresentable, CaseIterable {
    case toDo = 0
    case epics = 1
    case inProgress = 2
    case backlog = 3
    case finished = 4
    case archived = 5

    static var allPageTitles: [String] { Self.allCases.map({ MainMenuOptions[$0] }) }

    static subscript(index: MainMenuOptions) -> String {
        get {
            switch index {
            case .toDo: return "To-Do"
            case .epics: return "Epics"
            case .inProgress: return "In Progress"
            case .backlog: return "Backlog"
            case .finished: return "Finished"
            case .archived: return "Archived"
            }
        }
    }

    var pageTitle: String { toString() }

    // MARK: MenuOptionRepresentable conformance

    func toString() -> String {
        return MainMenuOptions.allPageTitles[self.rawValue]
    }
}

