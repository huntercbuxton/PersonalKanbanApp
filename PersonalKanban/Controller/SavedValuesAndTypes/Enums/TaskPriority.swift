//
//  TaskPriority.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/16/20.
//

import Foundation


enum TaskPriority: Int, CaseIterable {
    case unassigned = 0, low, medium, high, highest

    var int64: Int64 { Int64(self.rawValue) }
    var string: String { String(describing: self) }

    static let defaultVal: TaskPriority = .unassigned
    init?(int64: Int64) { self.init(rawValue: Int(int64)) }
}

