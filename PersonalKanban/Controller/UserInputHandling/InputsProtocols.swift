//
//  Protocols.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/19/20.
//

import Foundation

protocol InputValidatable {
    var inputField: Inputs { get }
    var inputValidationDelegate: InputValidationDelegate? { get set }
}

protocol InputValidationDelegate: AnyObject {
    func inputUpdate(_ input: String?, from: Inputs)
}

public protocol InputsInterfaceDelegate: AnyObject {
    func enableSave()
    func disableSave()
}

extension InputsInterfaceDelegate {
    func enableSave() {}
    func disableSave() {}
}
