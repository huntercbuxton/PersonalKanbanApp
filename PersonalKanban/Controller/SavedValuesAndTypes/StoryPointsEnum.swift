//
//  StoryPointsEnum.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/12/20.
//

import Foundation

enum StoryPoints: Int, RawRepresentable, CaseIterable {
    case unassigned = 0
    case two = 1
    case four = 2
    case eight = 3
    case sixteen = 4

    init?(from value: Int64) {
        self.init(rawValue: Int(value))
    }

    var displayTitle: String { String(describing: self) }
}

