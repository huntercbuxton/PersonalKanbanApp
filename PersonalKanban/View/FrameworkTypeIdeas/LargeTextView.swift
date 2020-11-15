//
//  LargeTextView.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/18/20.
//

import UIKit

public class LargeTextView: UITextView, UITextViewDelegate {

    // MARK: - InputValidationDelegate

    let inputField = Inputs.notes

    weak var inputValidationDelegate: InputValidationDelegate?
    weak var groupObserver: GroupUpdateObserver?
    let groupID = Inputs.notes

    static let defaultInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)

    // MARK: - UITextViewDelegate

    open func textViewDidChange(_ textView: UITextView) {
        self.inputValidationDelegate?.inputUpdate(textView.text, from: inputField)
    }

    // MARK: - initialisors

    convenience init(text: String? = "") {
        self.init()
//        layer.cornerRadius = SavedStyles.textInputCornerRadius
//        layer.borderWidth = SavedStyles.textInputBorderWidth
//        layer.borderColor = SavedStyles.textInputBorderColor
//        font = SavedStyles.defaultTextViewFont
//
//        translatesAutoresizingMaskIntoConstraints = false
//        heightAnchor.constraint(equalToConstant: SavedLayouts.defaultTextViewHeight).isActive = true

        
    }

    public init(placeholder: String, group: GroupUpdateObserver, text: String = "") {
        super.init(frame: .zero, textContainer: nil)
        layer.cornerRadius = SavedStyles.textInputCornerRadius
        layer.borderWidth = SavedStyles.textInputBorderWidth
        layer.borderColor = SavedStyles.textInputBorderColor
        font = SavedStyles.defaultTextViewFont

        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: SavedLayouts.defaultTextViewHeight).isActive = true

        self.textContainerInset = SavedLayouts.defaultTextViewInsets
        self.delegate = self

        self.groupObserver = group
        self.text = text
        self.groupObserver?.register(groupID: groupID, savedValue: self.text)

    }

    public init() {
        super.init(frame: .zero, textContainer: nil)
        self.textContainerInset = SavedLayouts.defaultTextViewInsets
        self.delegate = self
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
