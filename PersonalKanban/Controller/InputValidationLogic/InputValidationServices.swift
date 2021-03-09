//
//  InputValidationServices.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/14/20.
//

import Foundation
import UIKit

struct InputValidationServices {

    mutating func getState(_ forInput: String?) -> ChangeResult {
        for (key, value) in titleChecks {
            for test in value {
                if test(forInput!) {
                    return key
                }
            }
        }
        return .noError
    }

    mutating func updateSavePredicate(_ value: String?) {
        self.noChanges = { $0 == value }
    }

    var noChanges: ((String?) -> Bool) = { $0 == "" }

    // these closures will never need to be modified
    let emptyPredicate: (String) -> Bool  = { $0.isEmpty }
    let onlyWhitespaceAndNewlinesPred: (String) -> Bool = {$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty}
    let titleTooLong: (String) -> Bool = {
        if UIDevice.current.userInterfaceIdiom != .pad {
            return $0.count > 60
        } else {
            return false
        }
    }
    // for testing purposes only atm
    var illegalString: (String) -> Bool = { $0 == "a title that already exists" }

    var defaultTest: [ (String) -> Bool ] { [ emptyPredicate ] }
    lazy var testList: [ (String) -> Bool ] = []

    typealias TestPredicate = (String) -> Bool
    lazy var titleChecks: [ChangeResult: [TestPredicate]] = [
        .noChange: [self.noChanges],
        .erEmpty: [self.emptyPredicate],
        .erTooLong: [self.titleTooLong]
    ]
    lazy var notesTests: [ChangeResult: [TestPredicate]] = [
        .noChange: [self.noChanges],
        .erEmpty: [self.emptyPredicate]
    ]

    mutating func setTestList(for input: Inputs) {
        switch input {
        case .title:
            self.testList = [ onlyWhitespaceAndNewlinesPred, titleTooLong ]
        default:
            self.testList = []
        }
    }
}
