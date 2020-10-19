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

    // MARK: - UITextViewDelegate

    open func textViewDidChange(_ textView: UITextView) {
        self.inputValidationDelegate?.inputUpdate(textView.text, from: inputField)
    }

    // MARK: - styling and layout

    public func setupLayout(in stackView: UIStackView) {
        translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(self)
        let widthConst: CGFloat = stackView.layoutMargins.right*2.0
        print(String(describing: widthConst))
        widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -widthConst).isActive = true
        heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        isScrollEnabled = false
        layer.borderWidth = 2.5
        layer.borderColor = UIColor.systemGray5.cgColor
        layer.cornerRadius = 8
    }

    // MARK: - initialisors

    convenience init(text: String = "",
                     borderWidth: CGFloat = 2.0,
                     cornerRadius: CGFloat = 5,
                     borderColor: CGColor = UIColor.systemGray5.cgColor) {
        self.init()
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor
    }

    public init() {
         super.init(frame: .zero, textContainer: nil)
         self.textContainerInset = UIEdgeInsets(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0)
        self.delegate = self
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
