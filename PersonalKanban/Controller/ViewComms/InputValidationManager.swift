//
//  InputValidationHandler.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/18/20.
//

import UIKit



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
