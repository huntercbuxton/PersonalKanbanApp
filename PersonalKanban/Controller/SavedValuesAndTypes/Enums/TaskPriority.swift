//
//  TaskPriority.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/16/20.
//

import Foundation

enum TaskPriority: Int, CaseIterable, MORawRepresentable {
    case unassigned = 0, low, medium, high, highest

    typealias MOValue = Int64

    var moPropertyKey: String { "priority" }

    static var caseDefault: Int64 { Self.unassigned.moValue }
}
