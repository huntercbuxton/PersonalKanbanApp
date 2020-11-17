//
//  Enums.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/19/20.
//

import Foundation

public enum Inputs: String, Hashable {
    case title = "UITextField - title for Compose Task"
    case notes = "UITextView - notes for Compose Task"
    case epic
    case folder
    case position
    case storypoints
    case archive
}

public enum InputErrors: Int, Hashable {
    case nilValue = 0, requiredField, conflictData, invalidDate, conflictSchedule
}
