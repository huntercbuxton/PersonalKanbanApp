//
//  InputsManager.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/13/20.
//

import Foundation

public protocol SelectionDelegateToRuleThemAll: EpicsSelectorDelegate, StoryPointSelectorDelegate, WorkflowStatusSelectorDelegate {

}

class InputStateManager: InputsModelManager {

    let persistence: PersistenceManager!
    var task: Task?

    var inputState: InputState = .none
    weak var stateDelegate: ManagedInputsStateDelegate?

    var epic: Epic? {
        didSet {
            persistence.save()
            self.stateDelegate?.update(epic: epic, at: .epic)
        }
    }

    var storyPoints: StoryPoints {
        didSet {
            persistence.save()
            self.stateDelegate?.update(storyPoints: storyPoints, at: .storypoints)
        }
    }

    var lastFolder: TaskFolder
    var folderUpdate: TaskFolder {
        willSet {
            if newValue != folderUpdate { lastFolder = folderUpdate }
        }
        didSet {
            persistence.save()
            stateDelegate?.update(position: statusUpdate, at: .position)
        }
    }

    var isArchivedUpdate: Bool {
        get { folderUpdate == .archived }
        set {
            if newValue {
                folderUpdate = .archived
            } else {
                folderUpdate = lastFolder
            }
        }
    }

    var statusUpdate: WorkflowPosition? { self.folderUpdate.status }

    func update(value: String?, from: Inputs) -> ChangeResult {
        print("value.count was \(value?.count)")
        print("InputStateManager called \(#function) with value of \(value) ")
        let testResult = self.registeredInputs[from]!.getState(value!)
        print("testResult was \(testResult)")
        if testResult == .noError {
            stateDelegate?.updateState(.valid)
        } else {
            stateDelegate?.updateState(.invalid)
        }

        loggedTest[from] = testResult
        return testResult
    }

    var loggedTest: [Inputs: ChangeResult] = [ .title: .noChange, .notes: .noChange]

    func register(groupID: Inputs, savedValue: String?) {
        registeredInputs[groupID] = InputValidationServices()
        registeredInputs[groupID]!.updateSavePredicate(savedValue)
        registeredInputs[groupID]!.setTestList(for: groupID)
    }

    func register(groupID: Inputs) -> WorkflowPosition? {
        registeredInputs[groupID] = InputValidationServices()
        return statusUpdate
    }

    func register(groupID: Inputs) -> StoryPoints {
        return self.storyPoints
    }

    func register(groupID: Inputs) -> Epic? {
        return self.epic
    }

    var registeredInputs: [Inputs: InputValidationServices] = [:]

    init(persistence: PersistenceManager, task: Task?, stateDelegate: ManagedInputsStateDelegate, defaultFolder: TaskFolder?) {
        self.task = task
        self.persistence =  persistence
        self.stateDelegate = stateDelegate
        let firstFolder = task?.computedFolder ?? defaultFolder ?? TaskFolder()
        self.folderUpdate = firstFolder
        self.lastFolder = firstFolder
        self.epic = task?.epic
        self.storyPoints = task?.storyPointsEnum ?? StoryPoints()
    }
}

// EpicsSelectorDelegate protocol conformances
extension InputStateManager {
    func select(epic: Epic) {
        self.epic = epic
    }
}

// StoryPointsSelectorDelegat mprotocol conformances
extension InputStateManager {
    func select(storyPoints: StoryPoints) {
        self.storyPoints = storyPoints
    }
}

// WorkflowStatusSelectorDelegate protocol conformances
extension InputStateManager {
    func select(workflowStatus: WorkflowPosition) {
         folderUpdate = workflowStatus.folder
    }
}
