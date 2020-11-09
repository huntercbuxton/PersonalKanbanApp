//
//  InputValidationHandler.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/18/20.
//

import UIKit

class InputTracker {
    let textField: Inputs
    var input: String = ""
    var approved: Bool = false { didSet { /* print("self.approved == \(self.approved). self.input == \(self.input) */ } }
    var wrappedValue: String? {
        get {
            return self.input
        }
        set {
            self.approved = true
            guard let inputVal = newValue else {
                approved = false
                return
            }
            self.input = inputVal
            if !isEmpty(inputVal) {
                approved = false
                return
            }
        }
    }

    func isEmpty(_ input: String) -> Bool {
        let input1 = input.trimmingCharacters(in: .whitespacesAndNewlines)
        print(" input1.count == \(input1.count )")
        if input1.isEmpty { return false
        } else { return true }
    }

    init(textField: Inputs, _ input: String, _ failedTests: [InputErrors: Inputs?]?) {
        self.textField = textField
    }
}

class InputValidationManager: InputValidationDelegate {

    weak var delegate: InputsInterfaceDelegate?

    var inputTrackers = [ Inputs.title: InputTracker(textField: .title, "", nil),
                          Inputs.notes: InputTracker(textField: .notes, "", nil) ]

    // MARK: - InputValidationDelegate

    func inputUpdate(_ input: String?, from: Inputs) {
        inputTrackers[from]!.wrappedValue = input
        if inputTrackers[from]!.approved {
            delegate?.enableSave()
        } else {
            delegate?.disableSave()
        }
    }

}
