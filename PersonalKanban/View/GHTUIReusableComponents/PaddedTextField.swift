//
//  PaddedTextField.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/14/20.
//

import UIKit

open class PaddedTextField: UITextField, InputValidatable, UITextFieldDelegate {

    // MARK: - InputValidatable

    let inputField = Inputs.title

    weak var inputValidationDelegate: InputValidationDelegate?

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

    // MARK: - for the padding around the border

    let inset: CGFloat = 10

    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
      }

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
      }

    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
      }

    // MARK: - styling and layout

    @objc open func respondToChange() {
        self.inputValidationDelegate!.inputUpdate(self.text, from: inputField)
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

    }

    // MARK: - initializers
    public convenience init(placeholder text: String) {
         self.init()
         firstSetup()
         self.placeholder = text
     }

    public init() {
        super.init(frame: .zero)
        firstSetup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
