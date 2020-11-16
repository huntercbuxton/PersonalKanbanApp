//
//  StoryPointsEnum.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/12/20.
//

import Foundation
import UIKit

enum StoryPoints: Int, CaseIterable {
    case unassigned = 0, two, four, eight, sixteen

    var rawValueInt64: Int64 { Int64(self.rawValue) }
    var toString: String { String(describing: self) }

    public static let defaultVal: StoryPoints = .unassigned

    init?(_ rawValue: Int64) {
        self.init(rawValue: Int(rawValue))
    }
}


