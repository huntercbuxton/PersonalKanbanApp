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

    private let defaultHeight: CGFloat = 200.0
    private let defaultBorderWidth: CGFloat = 2.5
    private let defaultBorderColor: CGColor = UIColor.systemGray5.cgColor
    private let defaultCornerRadius: CGFloat = 8
    private let defaultFont: UIFont = UIFont.preferredFont(forTextStyle: .body)

    static let defaultInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)

    // MARK: - UITextViewDelegate

    open func textViewDidChange(_ textView: UITextView) {
        self.inputValidationDelegate?.inputUpdate(textView.text, from: inputField)
    }


    // MARK: - initialisors

    convenience init(text: String? = "") {
        self.init()
        layer.cornerRadius = defaultCornerRadius
        layer.borderWidth = defaultBorderWidth
        layer.borderColor = defaultBorderColor
        font = defaultFont

        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: defaultHeight).isActive = true
    }

    public init() {
        super.init(frame: .zero, textContainer: nil)
        self.textContainerInset = LargeTextView.defaultInsets
        self.delegate = self
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
