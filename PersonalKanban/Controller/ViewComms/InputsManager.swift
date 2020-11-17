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
            if newValue != folderUpdate  { lastFolder = folderUpdate }
        }
        didSet {
            persistence.save()
            stateDelegate?.update(position: statusUpdate, at: .position)
        }
    }

    var isArchivedUpdate: Bool {
        get { folderUpdate == .archived }
        set {
            if newValue { folderUpdate = .archived }
            else { folderUpdate = lastFolder }
        }
    }

    var statusUpdate: WorkflowPosition? { self.folderUpdate.status }

    func update(value: String?, from: Inputs) -> ChangeResult {

        print("value.count was \(value?.count)")
        print("InputStateManager called \(#function) with value of \(value) ")
        let testResult = self.registeredInputs[from]!.getState(value!)
        print("testResult was \(testResult)")
        if testResult == .noError {  stateDelegate?.updateState(.valid) }
        else { stateDelegate?.updateState(.invalid) }

        loggedTest[from] = testResult
        return testResult
    }


    var loggedTest: [Inputs : ChangeResult] = [ .title: .noChange, .notes: .noChange]

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










//
//
//enum InputStateChange: Int {
//    case none = 0
//    case validate
//    case invalidate
//    case valid
//    case invalid
//    case setNone
////    case setInvalidate
////    case setValidate
////    case setValid
////    case setInvalid
//}
//
//enum InputManagementType {
//    case none
//    case action
//    case change
//    case validation
////    case metaState
////    case nonState
//}
//
//enum ManagedInputModelStates {
//    case noInput
//    case noChange
//    case valid
//    case invalid
//    case saved
//}
//
//protocol InputStateManagerDelegate: AnyObject {
//    func updateState(_ state: InputState)
//    func inputManager(isArchived: Bool, result: ChangeResult?)
//    func inputManager(status: WorkflowPosition, result: ChangeResult?)
//    func inputManager(epic: Epic?, result: ChangeResult?)
//    func inputManager(storyPoints: StoryPoints, result: ChangeResult?)
//    func inputManager(stickyNote: String?, result: ChangeResult?)
//    func inputManager(title: String, result: ChangeResult?)
//    func inputManager(dueDate: Date?, result: ChangeResult?)
//    func inputManager(dateUpdated: Date, result: ChangeResult?)
//
//    func modelManager(isArchived: Bool, action: )
//    func modelManager(status: WorkflowPosition, result: ChangeResult?)
//    func modelManager(epic: Epic?, result: ChangeResult?)
//    func modelManager(storyPoints: StoryPoints, result: ChangeResult?)
//    func modelManager(stickyNote: String?, result: ChangeResult?)
//    func modelManager(title: String, result: ChangeResult?)
//    func modelManager(dueDate: Date?, result: ChangeResult?)
//    func modelManager(dateUpdated: Date, result: ChangeResult?)
//
////    func inputChange(
//    func delete()
//}
//
//extension InputStateManagerDelegate {
//    func updateState(_ state: InputState, error: ChangeResult?) {}
//    func inputManager(isArchived: Bool, error: ChangeResult? = .noChange) {}
//    func inputManager(status: WorkflowPosition, error: ChangeResult? = .noChange) {}
//    func inputManager(epic: Epic?, error: ChangeResult? = .noChange) {}
//    func inputManager(storyPoints: StoryPoints, error: ChangeResult? = .noChange) {}
//    func inputManager(stickyNote: String?, error: ChangeResult? = .noChange) {}
//    func inputManager(title: String, error: ChangeResult? = .noChange) {}
//    func inputManager(dueDate: Date?, error: ChangeResult? = .noChange) {}
//    func inputManager(dateUpdated: Date, error: ChangeResult? = .noChange) {}
//    func delete() {}
//}
