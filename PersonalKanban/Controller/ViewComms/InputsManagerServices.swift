//
//  InputsManagerServices.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/16/20.
//

import Foundation

public enum InputState: Hashable {
    case valid, invalid, none
}

public protocol InputsModelManager: SelectionDelegateToRuleThemAll {
    func update(value: String?, from: Inputs) -> ChangeResult
//    func update(status: WorkflowPosition?) -> Bool
    func register(groupID: Inputs, savedValue: String?)
    func register(groupID: Inputs) -> WorkflowPosition?
    func register(groupID: Inputs) -> StoryPoints
    func register(groupID: Inputs) -> Epic?
}

public protocol ManagedInputsStateDelegate: AnyObject {
    func updateState(_ newState: InputState)
    func update(position: WorkflowPosition?, at: Inputs)
    func update(epic: Epic?, at: Inputs)
    func update(storyPoints: StoryPoints, at: Inputs)
}

//protocol InputModelPersistance {
//    func persist(change group: ManagedInputGroups) -> Bool
//}
//
//protocol InputModelDisplay: AnyObject {
//    func inputModel(change value: String, for group: ManagedInputGroups)
//}

public enum ChangeResult: Hashable, CaseIterable {
    case noChange
    case noError
    case erEmpty
    case erTooLong
    case erDuplicate
    case erOther
}
