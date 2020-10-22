//
//  InputValidationHandler.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/18/20.
//

import Foundation
import UIKit

//class InputTracker {
//    let textField: Inputs
//    var input: String = ""
//    var approved: Bool = false {
//        didSet {
//            print("self.approved == \(self.approved). self.input == \(self.input)")
//        }
//    }
//    var wrappedValue: String? {
//        get {
//            return self.input
//        }
//        set {
//            self.approved = true
//            if isNil(newValue) {
//                approved = false
//                return
//            }
//            self.input = newValue!
//            if !isEmpty(newValue!) {
//                approved = false
//                return
//            }
//        }
//    }
//
//    func isNil(_ input: String?) -> Bool {
//        if input != nil { return false
//        } else { return true }
//    }
//    func isEmpty(_ input: String) -> Bool {
//        let input1 = input.trimmingCharacters(in: .whitespacesAndNewlines)
//        print(" input1.count == \(input1.count )")
//        if input1.isEmpty { return false
//        } else { return true }
//    }
//
//    init(textField: Inputs, _ input: String, _ failedTests: [InputErrors: Inputs?]?) {
//        self.textField = textField
//    }
//}
//
//public class InputValidationManager: InputValidationDelegate {
//    // MARK: - InputValidationManager
//    func sendErrorsUpdate() -> [InputErrors: String] { return [:] }
//    // MARK: - InputValidationDelegate
//    weak var delegate: InputsInterfaceDelegate?
//    func inputUpdate(_ input: String?, from: Inputs) {
//        inputTrackers[from]!.wrappedValue = input
//        if inputTrackers[from]!.approved {
//            delegate!.enableSave()
//        } else {
//            delegate!.disableSave()
//        }
//    }
//    var inputTrackers = [ Inputs.title: InputTracker(textField: Inputs.title, "", nil),
//                          Inputs.notes: InputTracker(textField: .notes, "", nil) ]
//    func updateInputErrors() { }
//    // MARK: - private implementation
////    private var inputCheckers: [InputChecker] = []
//    var inputErrors: [InputErrors: String] = [:] {
//        didSet { }
//        willSet { }
//    }
//    func reset() { }
//}
