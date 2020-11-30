//
//  InputFieldTracker.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/12/20.
//

import Foundation

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
        if input1.isEmpty { return false
        } else { return true }
    }

    init(textField: Inputs, _ input: String, _ failedTests: [InputErrors: Inputs?]?) {
        self.textField = textField
    }
}
