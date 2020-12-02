//
//  InputValidationHandler.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/18/20.
//

import UIKit

class EpicInputValidationManager: InputValidationDelegate {

    // MARK: - properties

    weak var delegate: InputsInterfaceDelegate?
    var inputTrackers = [ Inputs.title: InputTracker(textField: .title, "", nil),
                          Inputs.notes: InputTracker(textField: .notes, "", nil) ]

    // MARK: - InputValidationDelegate conformance

    func inputUpdate(_ input: String?, from: Inputs) {
        inputTrackers[from]!.wrappedValue = input
        if inputTrackers[from]!.approved {
            delegate?.enableSave()
        } else {
            delegate?.disableSave()
        }
    }

    // MARK: - initialization

    init(delegate: InputsInterfaceDelegate) {
        self.delegate = delegate
    }

    init() {}
}
