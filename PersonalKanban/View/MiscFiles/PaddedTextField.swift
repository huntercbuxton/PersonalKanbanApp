//
//  PaddedTextField.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/14/20.
//

import UIKit

// used as the input field for the 'stickyNote' property of tasks
open class PaddedTextField: UITextField, UITextFieldDelegate {

    // MARK: - properties

    weak var groupObserver: InputsModelManager?
    weak var epicUpdateDelegate: EpicInputValidationManager?
    let groupID = Inputs.title
    let inset: CGFloat = 10

    // MARK: - UITextFieldDelegate

    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        let maxLength = 80
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }

    // MARK: - styling and layout

    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
    }

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
    }

    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
    }

    // this causes the keyboard to be dismissed when the return key is pressed.
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        superview?.endEditing(true)
        return false
    }

    func firstSetup() {
        self.addTarget(self, action: #selector(respondToChange), for: UIControl.Event.editingChanged)
        self.delegate = self
        self.spellCheckingType = .no
        self.autocapitalizationType = .none
        font = SavedStyles.defaultTextFieldFont

        layer.borderWidth = SavedStyles.textInputBorderWidth
        layer.borderColor = SavedStyles.textInputBorderColor
        layer.cornerRadius = SavedStyles.textInputCornerRadius

        backgroundColor = .systemBackground
    }

    @objc open func respondToChange() {
        groupObserver?.update(value: self.text, from: .title)
        epicUpdateDelegate?.inputUpdate(self.text, from: .title)
    }

    // MARK: - initializers

    public convenience init(placeholder text: String) {
         self.init()
         firstSetup()
         self.placeholder = text
     }

    public init(placeholder: String, group: InputsModelManager, text: String = "") {
        super.init(frame: .zero)
        firstSetup()
        self.placeholder = placeholder
        self.groupObserver = group
        self.text = text
        self.groupObserver?.register(groupID: self.groupID, savedValue: self.text)
    }

    public init() {
        super.init(frame: .zero)
        firstSetup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
