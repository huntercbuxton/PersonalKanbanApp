//
//  StoryPointsEnum.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/12/20.
//

import Foundation
import UIKit

public enum StoryPoints: Int, CaseIterable, MORawRepresentable {
    case unassigned = 0, two, four, eight, sixteen

    typealias MOValue = Int64

    var moPropertyKey: String { "storypoints" }

    static var caseDefault: MOValue { Self.unassigned.moValue }

}
