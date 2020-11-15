//
//  InputsManager.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/13/20.
//

import Foundation


protocol InputStateManagerDelegate: AnyObject {
    func updateState(_ state: InputState)
}

public protocol GroupUpdateObserver: AnyObject {
    func update(value: String?, from: Inputs) -> ChangeResult
    func register(groupID: Inputs, savedValue: String?)
}

enum InputState: Hashable {
    case valid, invalid, none
}

class InputStateManager: GroupUpdateObserver {

    func update(value: String?, from: Inputs) -> ChangeResult {
        print("value.count was \(value?.count)")
        print("InputStateManager called \(#function) with value of \(value) ")
        let testResult = self.registeredInputs[from]!.getState(value!)
        print("testResult was \(testResult)")

        if from == .title {
            if testResult == .noError { delegate?.updateState(.valid) }
            else if testResult == .noChange { delegate?.updateState(.none)}
            else { delegate?.updateState(.invalid) }
        }

        loggedTest[from] = testResult
        return testResult
    }


    var loggedTest: [Inputs : ChangeResult] = [ .title: .noChange, .notes: .noChange]

    func register(groupID: Inputs, savedValue: String?) {
        registeredInputs[groupID] = InputValidationServices()
        registeredInputs[groupID]!.updateSavePredicate(savedValue)
        registeredInputs[groupID]!.setTestList(for: groupID)
    }

    var registeredInputs: [Inputs: InputValidationServices] = [:]
    weak var delegate: InputStateManagerDelegate?

    init(delegate: InputStateManagerDelegate) {
        self.delegate = delegate
    }
}



